require "test_helper"

class HarmoniaTestMailTest < Test::Unit::TestCase
  def setup
    ::Mail::TestMailer.deliveries.clear
    @mail = Harmonia::Mail::HarmoniaTest.new("Chris")
  end

  def test_sends_mail_to_harmonia_test_delegate
    @mail.send

    assert Mail::TestMailer.deliveries.find { |m| m.subject == "Please ignore. This is a test email from Harmonia." }
  end
end