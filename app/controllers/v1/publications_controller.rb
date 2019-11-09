class V1::PublicationsController < ApplicationController

	def createPublication
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end
		
		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		id = Token.getIdByToken(params[:token])

		if params[:url].nil? || params[:url].empty?
			if params[:text].nil? || params[:text].empty?
				render json: {error: true, msg: 'Se requiere contenido para la publicacion', auth: true}
			return
			end
		end

		privacy = params[:private].nil? || params[:private].empty? ? false : params[:private]
		pType = params[:url].nil? || params[:url].empty? ? 'text' : 'img/text'

		url = params[:url].nil? || params[:url].empty? ? '' : params[:url]
		text = params[:text].nil? || params[:text].empty? ? '' : params[:text]

		hashTags = [];
		tags = [];

		if !params[:text].nil? && !params[:text].empty?
			hashTags = identifyHashTags(params[:text])
			tags = identifyTags(params[:text])
		end

		phash = ''

		for i in hashTags do 
			hashtag = i.tr('#', '')
			dbHash = HashTag.where(:name => hashtag).first
			if dbHash.blank?
				newHash = HashTag.new()
				newHash.name = hashtag
				newHash.author = id

				if newHash.save
					phash = phash + ' ' + newHash.id.to_s
				end
			else
				phash = phash + ' ' + dbHash.id.to_s
			end
		end

		newPublication = Publication.new()
		newPublication.author = id
		newPublication.private = privacy
		newPublication.hashtags = phash
		newPublication.ptype = pType
		newPublication.text = text
		newPublication.content_url = url

		newPublication.save

		for i in tags do
			tag = i.tr('@', '')
			target = User.where(:nickname => tag).first
			if target.blank?
				tags.pop(i)
			else 
				newTag = Ptag.new()
				newTag.author = id
				newTag.target = target.id
				newTag.tag_type = 'publication'
				newTag.content = newPublication.id

				newTag.save
			end
		end

		render json: {error: false, msg: 'Publicacion exitosa', publication: newPublication}
	end

	def identifyHashTags(text)
		return text.scan(/#\w+/).flatten
	end

	def identifyTags(text)
		return text.scan(/@\w+/).flatten
	end

	def getMyPublications
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end
		
		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		id = Token.getIdByToken(params[:token])

		publications = Publication.where(:author => id).all

		render json: {error: false, content: publications.order('created_at DESC')}
	end

	def getUserPublications
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end
		
		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		if params[:id].nil? || params[:id].empty?
			render json: {error: true, msg: 'Se requiere el id del usuario', find: false}
			return
		end

		if !User.UserExist(params[:id])
			render json: {error: true, msg: 'Usuario no encontrado', find: false}
			return
		end

		id = Token.getIdByToken(params[:token])

		if !User.CanSee(id, params[:id])
			render json: {error: true, msg: 'Perfil privado', find: true, CanSee: false}
			return
		end

		if !User.IsPrivate(params[:id]) && !Follow.DoesIfollow(id, params[:id])
			publications = Publication.where(:author => params[:id], :private => false)
			render json: {error: false, content: publications.order('created_at DESC'), find: true}
			return
		end
		
		publications = Publication.where(:author => params[:id])
		render json: {error: false, content: publications.order('created_at DESC'), find: true}
		return
	end

	def countUserPublications
		if params[:id].nil? || params[:id].empty?
			render json: {error: true, msg: 'Se requiere el id del usuario', find: false}
			return
		end

		if !User.UserExist(params[:id])
			render json: {error: true, msg: 'Usuario no encontrado', find: false}
			return
		end

		count = Publication.where(:author => params[:id]).count
		render json: {error: false, count: count}		
	end

	def getMyFollowsPublications
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end
		
		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		id = Token.getIdByToken(params[:token])

		follows = Follow.WhoIFollow(id)

		publications = Publication.where(author: follows).all.order('created_at DESC')
		users = User.where(id: follows).select("id, nickname, profile_pic").all

		render json: {error: false, content: publications, users: users}
	end
end
