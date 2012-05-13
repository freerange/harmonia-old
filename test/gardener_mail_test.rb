require "test_helper"

class GardenerMailTest < Test::Unit::TestCase
  def setup
    ::Mail::TestMailer.deliveries.clear
    @mail = Harmonia::Mail::Gardener.new("Tom")
  end

  def test_sends_mail_to_gardener_delegate
    @mail.send

    assert Mail::TestMailer.deliveries.find { |m| m.subject == "Tom, it's your turn to water the plants." }
  end
end