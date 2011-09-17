require "test_helper"

class WeeknotesMailTest < Test::Unit::TestCase
  def setup
    ::Mail::TestMailer.deliveries.clear
    @mail = Harmonia::Mail::Weeknotes.new("Tom")
  end

  def test_sends_mail_to_weeknotes_delegate
    @mail.send

    assert Mail::TestMailer.deliveries.find { |m| m.subject == "Tom is writing the notes this week." }
  end
end