require 'test_helper'

class VerifyMailerTest < ActionMailer::TestCase
  test "sendVerify" do
    mail = VerifyMailer.sendVerify
    assert_equal "Sendverify", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
