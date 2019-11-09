class V1::StoryController < ApplicationController
	def createStory
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
				render json: {error: true, msg: 'Se requiere contenido para la historia', auth: true}
			return
			end
		end

		privacy = params[:private].nil? || params[:private].empty? ? false : params[:private]
		pType = params[:url].nil? || params[:url].empty? ? 'text' : 'img/text'

		url = params[:url].nil? || params[:url].empty? ? '' : params[:url]
		text = params[:text].nil? || params[:text].empty? ? '' : params[:text]
		bcolor = params[:bcolor].nil? || params[:bcolor].empty? ? '#000' : params[:bcolor]

		hashTags = [];

		phash = ''

		if !params[:text].nil? && !params[:text].empty?
			hashTags = identifyHashTags(params[:text])
		end

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

		newStory = Story.new()
		newStory.author = id
		newStory.private = privacy
		newStory.hashtags = phash
		newStory.ptype = pType
		newStory.text = text
		newStory.content_url = url
		newStory.bcolor = bcolor

		if newStory.save
			render json: {error: false, msg: 'Historia publicada exitosamente', story: newStory}
		end

	end

	def getMyStories
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end
		
		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		id = Token.getIdByToken(params[:token])

		stories = Story.where(:author => id).all

		render json: {error: false, content: stories.order('created_at DESC')}
	end

	def getUserStories
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
			stories = Story.where(:author => params[:id], :private => false)
			render json: {error: false, stories: stories, find: true}
			return
		end
		
		stories = Story.where(:author => params[:id])
		render json: {error: false, stories: stories, find: true}
		return
	end

	def GetStoriesPreview
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

		stories = Story.where(author: follows).all

		res = []

		for i in follows do
			res.push(Story.where(author: i[:followed]).last)
		end

		users = User.where(id: follows).select("id, nickname").all

		render json: {error: false, stories: res, users: users}
	end

	def identifyHashTags(text)
		return text.scan(/#\w+/).flatten
	end
end
