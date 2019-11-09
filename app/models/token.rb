class Token < ApplicationRecord
	def self.generateToken(id)
		token = self.generate_token

		newToken = self.new()
		newToken.token = token
		newToken.user_id = id

		if newToken.save
			return token
		end
	end

	def self.generate_token
		loop do
	    	token = SecureRandom.hex(10)
	    	break token unless self.where(token: token).exists?
		end
	end

	def self.verifyToken(token)
		dbToken = self.where(:token => token).first

		if dbToken.blank?
			return false
		end

		return true
	end

	def self.getIdByToken(token)
		dbToken = self.where(:token => token).first

		return dbToken.user_id
	end
end
