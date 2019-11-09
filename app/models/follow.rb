class Follow < ApplicationRecord
	def self.DoesIfollow(id, target)
		follow = self.where(:follower => id, :followed => target).first
		if follow.blank?
			return false
		else
			return true
		end
	end

	def self.WhoIFollow(id)
		follows = self.where(:follower => id).select("followed").all
		return follows
	end

	def self.GetState(id, target)
		if Followreq.AlreadySendReq(id, target)
			return 3
		end

		if self.DoesIfollow(id, target)
			return 2
		else
			return 1
		end
	end
end

#state 1:sin seguir 2:Seguido 3:solicitud enviada 4:bloqueado