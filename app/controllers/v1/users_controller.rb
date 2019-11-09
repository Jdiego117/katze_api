class V1::UsersController < ApplicationController
	
	require "bcrypt"

	def index
		@users = User.all

		render json: @users, status: :ok
	end

	def register
		if params[:name].nil? || params[:name].empty?
			render json: {error: true, msg: 'Se requiere el nombre'}
			return
		elsif params[:lastname].nil? || params[:lastname].empty?
			render json: {error: true, msg: 'Se requiere el apellido'}
			return
		elsif params[:nickname].nil? || params[:nickname].empty?
			render json: {error: true, msg: 'Se requiere el nombre de usuario'}
			return
		elsif params[:email].nil? || params[:email].empty?
			render json: {error: true, msg: 'Se requiere el correo electronico'}
			return
		elsif params[:country].nil? || params[:country].empty?
			render json: {error: true, msg: 'Se requiere el pais'}
			return
		elsif params[:city].nil? || params[:city].empty?
			render json: {error: true, msg: 'Se requiere su ciudad de residencia'}
			return
		elsif params[:birthdate].nil? || params[:birthdate].empty?
			render json: {error: true, msg: 'Se requiere la fecha de nacimiento'}
			return
		elsif params[:password].nil? || params[:password].empty?
			render json: {error: true, msg: 'Se requiere una contraseña'}
			return
		end

		emailExist = User.where(:email => params[:email])
		nickExist = User.where(:nickname => params[:nickname])
		
		if !emailExist.empty?
			render json: {error: true, msg: 'El email esta en uso'}
			return
		elsif !nickExist.empty?
			render json: {error: true, msg: 'El nombre de usuario esta en uso'}
			return
		end

		newUser = User.new(user_params)

		hashed_password = BCrypt::Password.create(params[:password])
		newUser.password = hashed_password

		newUser.verify = false
		newUser.private = false
		newUser.profile_pic = 'profile.png'
		newUser.description = 'No hay descripcion'

		if newUser.save
			VerifyMailer.sendVerify(newUser.email, newUser.id).deliver_now
			render json: {error: false, msg: 'Cuenta registrada, enviamos un correo de verificacion'}
		else
			render json: {error: true, msg: 'Error inesperados'}
		end

	end

	def login
		if params[:email].nil? || params[:email].empty?
			render json: {error: true, msg: 'Se requiere el correo electronico', needVerify: false}
			return
		elsif params[:password].nil? || params[:password].empty?
			render json: {error: true, msg: 'Se requiere la contraseña', needVerify: false}
			return
		end

		user = User.where(:email => params[:email]).first

		if user.blank?
			render json: {error: true, msg: 'No hay ninguna cuenta asociada a este correo', needVerify: false}
			return
		end
		
		@user_hash = BCrypt::Password.new(user.password)

		if @user_hash != params[:password]
			render json: {error: true, msg: 'Contraseña incorrecta', needVerify: false}
			return
		elsif user.verify == false
			render json: {error: true, msg: 'Necesita verificar la cuenta', needVerify: true}
			return
		end

		token = Token.generateToken(user.id)

		render json: {error: false, msg: 'Logueado', needVerify: false, token: token}
	end

	def updateUser
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end

		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		id = Token.getIdByToken(params[:token])

		user = User.where(:id => id).first

		name = params[:name].nil? || params[:name].empty? ? user.name : params[:name]
		lastname = params[:lastname].nil? || params[:lastname].empty? ? user.lastname : params[:lastname]
		password = params[:password].nil? || params[:password].empty? ? user.password : BCrypt::Password.create(params[:password])
		profile_pic = params[:profile_pic].nil? || params[:profile_pic].empty? ? user.profile_pic : params[:profile_pic]
		nickname = params[:nickname].nil? || params[:nickname].empty? ? user.nickname : params[:nickname]
		description = params[:description].nil? || params[:description].empty? ? user.description : params[:description]
		country = params[:country].nil? || params[:country].empty? ? user.country : params[:country]
		city = params[:city].nil? || params[:city].empty? ? user.city : params[:city]


		if nickname != user.nickname
			dbUser = User.where(:nickname => nickname).first

			if !dbUser.blank?
				render json: {error: true, msg: 'El nombre de usuario ya esta en uso'}
				return
			end
		end

		user.name = name
		user.lastname = lastname
		user.password = password
		user.profile_pic = profile_pic
		user.nickname = nickname
		user.description = description
		user.country = country
		user.city = city

		if user.save
			render json: {error: false, msg: 'Datos actualizados correctamente', newData: user}
			return
		end
	end

	def getUserInfoByNick
		if params[:nickname].nil? || params[:nickname].empty?
			render json: {error: true, msg: 'Se requiere el nombre de usuario', find: false}
			return
		end

		user = User.where(:nickname => params[:nickname]).first

		if user.blank?
			render json: {error: true, msg: 'Usuario no encontrado', find: false}
			return
		end

		res = {
			nickname: user.nickname,
			name: user.name,
			country: user.country,
			city: user.city,
			profile_pic: user.profile_pic,
			description: user.description,
			private: user.private,
			id: user.id
		}

		render json: {error: false, msg: 'Usuario encontrado', find: true, user: res}

	end

	def getMyBasicInfo
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end

		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		id = Token.getIdByToken(params[:token])

		user = User.where(:id => id).first

		res = {
			nickname: user.nickname,
			name: user.name,
			private: user.private,
			id: user.id
		}

		render json: res
	end

	def getMyInfo
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end

		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		id = Token.getIdByToken(params[:token])

		user = User.where(:id => id).first

		if !user.blank?
			res = {
				nickname: user.nickname,
				name: user.name,
				lastname: user.lastname,
				email: user.email,
				country: user.country,
				city: user.city,
				profile_pic: user.profile_pic,
				birthdate: user.birthdate,
				description: user.description,
				private: user.private,
				id: user.id
			}

			render json: res
		end
		
	end

	def canSeeUser
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

		id = Token.getIdByToken(params[:token])

		user = User.where(:id => params[:id]).first

		if user.blank?
			render json: {error: true, msg: 'Usuario no encontrado', find: false}
			return
		end

		if user.private == false
			render json: {error: false, canSee: true, find: true}
			return
		else 
			follow = Follow.where(:follower => id, :followed => user.id).first
			if follow.blank?
				render json: {error: false, canSee: false, find: true}
				return
			else 
				render json: {error: false, canSee: true, find: true}
				return
			end
		end
	end

	def searchUserBasic
		if params[:query].nil? || params[:query].empty?
			render json: {error: true, msg: 'Se requiere la busqueda'}
			return
		end

		result = User.where("nickname LIKE ?", "#{params[:query]}%").select("nickname, profile_pic, id").all
		render json: {error: false, users: result}
	end

	private

	def user_params
		params.permit(:name, :lastname, :nickname, :email, :country, :city, :birthdate, :password)
	end
end
