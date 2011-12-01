require "test_helper"

class FireLogbookMailTest < Test::Unit::TestCase
  def setup
    ::Mail::TestMailer.deliveries.clear
    @mail = Harmonia::Mail::FireLogbook.new("James")
  end

  def test_sends_mail_to_fire_logbook_delegate
    @mail.send

    assert Mail::TestMailer.deliveries.find { |m| m.subject == "James, it's your turn to update the Fire Logbook today." }
  end
end