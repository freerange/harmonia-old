require "test_helper"

class MailTest < Test::Unit::TestCase
  def setup
    ::Mail::TestMailer.deliveries.clear
  end

  class TestMail < Harmonia::Mail
    def to_mail
      mail do
        subject "Hello Dave"
      end
    end
  end

  def test_yields_mail_to_given_block
    test_mail = TestMail.new("Anyone")
    test_mail.send
    assert_equal "Hello Dave", Mail::TestMailer.deliveries.first.subject
  end

  def test_defaults_reply_to_to_everyone_at_gofreerange
    ENV["REPLY_TO"] = nil
    test_mail = TestMail.new("Anyone")
    test_mail.send
    assert_equal ["everyone@gofreerange.com"], Mail::TestMailer.deliveries.first.reply_to
  end

  def test_sets_reply_to_to_team_reply_to_address
    ENV["REPLY_TO"] = "replyto@example.com"
    test_mail = TestMail.new("Anyone")
    test_mail.send
    assert_equal ["replyto@example.com"], Mail::TestMailer.deliveries.first.reply_to
  end
end