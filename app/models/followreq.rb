class Followreq < ApplicationRecord
	def self.AlreadySendReq(id, target)
		req = self.where(:userReq => id, :target => target).first
		if req.blank?
			return false
		else
			return true
		end
	end
end
