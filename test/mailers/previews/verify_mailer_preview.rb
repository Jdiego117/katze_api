# Preview all emails at http://localhost:3000/rails/mailers/verify_mailer
class VerifyMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/verify_mailer/sendVerify
  def sendVerify
    VerifyMailer.sendVerify('juan@juan.com', 1)
  end
end
