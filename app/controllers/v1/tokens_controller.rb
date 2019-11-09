class V1::TokensController < ApplicationController
	def getCurrentUser
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end

		token = Token.where(:token => params[:token]).first

		if token.blank?
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		user = User.where(:id => token.user_id).first

		render json: user
	end
end
