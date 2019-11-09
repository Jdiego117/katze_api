class VerifyMailer < ApplicationMailer
  def sendVerify(email, id)
  	@email = email
  	@code = generate_code(7)

  	newCode = Verify.new()
  	newCode.code = @code
  	newCode.user_id = id

  	if newCode.save
  		mail to: email, subject: 'Verificacion de cuenta Katze'
  	end
  end

  def generate_code(number)
    charset = Array('A'..'Z') + Array('a'..'z')
    Array.new(number) { charset.sample }.join
  end

end
