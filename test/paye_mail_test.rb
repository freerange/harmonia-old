require "test_helper"

class PayeMailTest < Test::Unit::TestCase
  def setup
    ::Mail::TestMailer.deliveries.clear
    @mail = Harmonia::Mail::Paye.new("Chris")
  end

  def test_sends_mail_to_paye_delegate
    @mail.send

    assert Mail::TestMailer.deliveries.find { |m| m.subject == "Chris, it's your turn to pay the queen (well, HMRC)." }
  end
end