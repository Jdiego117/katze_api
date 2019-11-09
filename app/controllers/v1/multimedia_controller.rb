class V1::MultimediaController < ApplicationController
	def getGallery
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end
		
		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		id = Token.getIdByToken(params[:token])

		gallery = Multimedium.where(:owner => id).all

		render json: {error: false, content: gallery}
	end

	def addContent
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end

		if params[:url].nil? || params[:url].empty?
			render json: {error: true, msg: 'Se requiere el url', auth: false}
			return
		end
		
		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		id = Token.getIdByToken(params[:token])

		privacy = params[:privacy].nil? || params[:privacy].empty? ? false : true

		newContent = Multimedium.new()

		newContent.owner = id
		newContent.privacy = privacy
		newContent.url = params[:url]

		if newContent.save
			render json: {error: false, content: newContent}
		end
	end
end