class V1::VerifiesController < ApplicationController
	def verify
		if params[:code].nil? || params[:code].empty?
			render json: {error: true, msg: 'Se requiere el codigo'}
			return
		end

		code = params[:code]

		dbCode = Verify.where(:code => code).first

		if dbCode.blank?
			render json: {error: true, msg: 'El codigo no ha sido encontrado'}
			return
		end

		user = User.find_by(id: dbCode.user_id)
		if user.update(verify: true)
			render json: {error: false, msg: 'Cuenta verificada exitosamente'}
			return
		end
	end

	def resendCode
		if params[:email].nil? || params[:email].empty?
			render json: {error: true, msg: 'Se requiere el correo electronico'}
			return
		end

		user = User.where(:email => params[:email]).first

		if user.blank?
			render json: {error: true, msg: 'No se encontro ninguna cuenta asociada a este correo'}
			return
		elsif user.verify == true
			render json: {error: true, msg: 'La cuenta ya ha sido verificada anteriormente'}
			return
		end

		VerifyMailer.sendVerify(user.email, user.id).deliver_now
		render json: {error: false, msg: 'Hemos reenviado el correo de verificacion'}
	end
end
