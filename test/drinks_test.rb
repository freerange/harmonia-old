require "test_helper"

class DrinksMailTest < Test::Unit::TestCase
  def setup
    ::Mail::TestMailer.deliveries.clear
    @mail = Harmonia::Mail::Drinks.new("James")
  end

  def test_sends_mail_to_drinks_delegate
    @mail.send

    assert Mail::TestMailer.deliveries.find { |m| m.subject == "James, it's your turn to organise drinks." }
  end
end
