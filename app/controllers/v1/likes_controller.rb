class V1::LikesController < ApplicationController
	def setLikePublication
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end
		
		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		if params[:id].nil? || params[:id].empty?
			render json: {error: true, msg: 'Se requiere el id del contenido', auth: true}
			return
		end

		id = Token.getIdByToken(params[:token])

		likeExist = Like.where(author: id, target: params[:id], target_type: 'publication').first

		if !likeExist.blank?
			render json: {error: true, msg: 'Ya te gusta esta publicacion', auth: true}
			return
		end

		newLike = Like.new()

		newLike.author = id
		newLike.target = params[:id]
		newLike.target_type = 'publication'

		if newLike.save
			render json: {error: false, msg: 'Tarea completada exitosamente', auth: true}
		end
	end

	def deleteLikePublication
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end
		
		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		if params[:id].nil? || params[:id].empty?
			render json: {error: true, msg: 'Se requiere el id del contenido', auth: true}
			return
		end

		id = Token.getIdByToken(params[:token])

		likeExist = Like.where(author: id, target: params[:id], target_type: 'publication').first

		if likeExist.blank?
			render json: {error: true, msg: 'No te gusta esta publicacion', auth: true}
			return
		end

		if Like.where(author: id, target: params[:id], target_type: 'publication').delete_all
			render json: {error: false, msg: 'Ya no te gusta'}
			return
		end
	end

	def countPublicationLikes
		if params[:id].nil? || params[:id].empty?
			render json: {error: true, msg: 'Se requiere el id del contenido', auth: true}
			return
		end

		count = Like.where(target_type: 'publication', target: params[:id]).count

		render json: {error: false, count: count, auth: true}
	end
end
