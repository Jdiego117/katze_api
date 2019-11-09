class V1::FollowsController < ApplicationController
	def getFollowStats
		if params[:id].nil? || params[:id].empty?
			render json: {error: true, msg: 'Se requiere el id'}
			return
		end

		user = User.where(:id => params[:id]).first

		if user.blank?
			render json: {error: true, msg: 'El usuario no existe'}
			return
		end

		followers = Follow.where(:followed => params[:id]).count
		followeds = Follow.where(:follower => params[:id]).count

		render json: {error: false, followers: followers, followeds: followeds}
	end

	def followUser
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end

		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		if params[:id].nil? || params[:id].empty?
			render json: {error: true, msg: 'Se requiere el id'}
			return
		end

		if !User.UserExist(params[:id])
			render json: {error: true, msg: 'El usuario no existe'}
			return
		end

		id = Token.getIdByToken(params[:token])

		if Follow.DoesIfollow(id, params[:id])
			render json: {error: true, msg: 'Ya sigues a este usuario', state: 2}
			return
		end

		if User.IsPrivate(params[:id])
			if Followreq.AlreadySendReq(id, params[:id])
				render json: {error: true, msg: 'Ya has enviado solicitud anteriormente', state: 3}
				return
			end

			newReq = Followreq.new()
			newReq.userReq = id
			newReq.target = params[:id]

			if newReq.save
				render json: {error: false, msg: 'Solicitud enviada', state: 3}
				return
			end
		end

		newFollow = Follow.new()

		newFollow.follower = id
		newFollow.followed = params[:id]

		if newFollow.save
			render json: {error: false, msg: 'Usuario seguido exitosamente', state: 2}
			return
		end
	end

	def getFollowState
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end

		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		if params[:id].nil? || params[:id].empty?
			render json: {error: true, msg: 'Se requiere el id'}
			return
		end

		if !User.UserExist(params[:id])
			render json: {error: true, msg: 'El usuario no existe'}
			return
		end

		id = Token.getIdByToken(params[:token])

		if Followreq.AlreadySendReq(id, params[:id])
			render json: {error: false, msg: 'has enviado solicitud', state: 3}
			return
		end

		if Follow.DoesIfollow(id, params[:id])
			render json: {error: false, msg: 'sigues a este usuario', state: 2}
			return
		else
			render json: {error: false, msg: 'No sigues a este usuario', state: 1}
			return
		end
	end

	def fastFollowAction
		if params[:token].nil? || params[:token].empty?
			render json: {error: true, msg: 'Se requiere el token', auth: false}
			return
		end

		if !Token.verifyToken(params[:token])
			render json: {error: true, msg: 'Token invalido', auth: false}
			return
		end

		if params[:id].nil? || params[:id].empty?
			render json: {error: true, msg: 'Se requiere el id'}
			return
		end

		if !User.UserExist(params[:id])
			render json: {error: true, msg: 'El usuario no existe'}
			return
		end

		id = Token.getIdByToken(params[:token])

		state = Follow.GetState(id, params[:id])

		if state == 1 #seguir
			if User.IsPrivate(params[:id])
				newReq = Followreq.new()
				newReq.userReq = id
				newReq.target = params[:id]
				if newReq.save
					render json: {error: false, msg: 'Solicitud enviada', state: 3}
					return
				end
			end
			newFollow = Follow.new()
			newFollow.follower = id
			newFollow.followed = params[:id]
			if newFollow.save
				render json: {error: false, msg: 'Usuario seguido exitosamente', state: 2}
				return
			end
		end

		if state == 2 #dejar de seguir
			if Follow.where(:follower => id, :followed => params[:id]).delete_all
				render json: {error: false, msg: 'Dejaste de seguir al usuario', state: 1}
				return
			end
		end

		if state == 3 #Cancelar solicitud
			if Followreq.where(:userReq => id, :target => params[:id]).delete_all
				render json: {error: false, msg: 'Solicitud cancelada', state: 1}
				return
			end
		end
	end
end

#state 1:sin seguir 2:Seguido 3:solicitud enviada 4:bloqueado
