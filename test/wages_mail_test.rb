require "test_helper"

class WagesMailTest < Test::Unit::TestCase
  def setup
    ::Mail::TestMailer.deliveries.clear
    @mail = Harmonia::Mail::Wages.new("Chris")
  end

  def test_sends_mail_to_wages_delegate
    @mail.send

    assert Mail::TestMailer.deliveries.find { |m| m.subject == "Chris, it's your turn to pay us some monies." }
  end
end