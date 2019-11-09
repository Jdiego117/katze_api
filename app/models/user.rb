class User < ApplicationRecord
	def self.CanSee(id, target) 
		user = self.where(:id => target).first
		if user.blank?
			return false
		end

		if user.private == false
			return true
		end

		if Follow.DoesIfollow(id, target)
			return true
		else
			return false
		end
	end

	def self.UserExist(id)
		user = self.where(:id => id).first
		if user.blank?
			return false
		else
			return true
		end
	end

	def self.IsPrivate(id)
		user = self.where(:id => id).first
		return user.private
	end
end
