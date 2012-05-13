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

  def test_defaults_to_to_everyone_at_gofreerange
    ENV["TO"] = nil
    test_mail = TestMail.new("Anyone")
    test_mail.send
    assert_equal ["everyone@gofreerange.com"], Mail::TestMailer.deliveries.first.to
  end

  def test_sets_to_to_to_address
    ENV["TO"] = "people@example.com"
    test_mail = TestMail.new("Anyone")
    test_mail.send
    assert_equal ["people@example.com"], Mail::TestMailer.deliveries.first.to
  end

  def sets_defaults_from_to_chaos_administrator
    ENV["FROM"] = nil
    test_mail = TestMail.new("Anyone")
    test_mail.send
    assert_equal ['"Chaos Administrator" <chaos@gofreerange.com>'], Mail::TestMailer.deliveries.first.from
  end

  def test_sets_from_to_from_address
    ENV["FROM"] = "person@example.com"
    test_mail = TestMail.new("Anyone")
    test_mail.send
    assert_equal ["person@example.com"], Mail::TestMailer.deliveries.first.from
  end

  def test_sets_the_charset_to_utf8
    test_mail = TestMail.new("Anyone")
    assert_equal "UTF-8", test_mail.to_mail.charset
  end
end