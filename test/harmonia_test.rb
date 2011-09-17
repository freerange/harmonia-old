require "test_helper"

class HarmoniaTest < Test::Unit::TestCase
  def setup
    ::Mail::TestMailer.deliveries.clear
  end

  def test_sends_mail_to_invoices_assignee_after_assignment
    stub_free_agent!([])
    Harmonia.new(store_path).assign(:invoices)

    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /it's your turn to do invoices.$/ }
  end

  def test_sends_mail_to_weeknotes_assignee_after_assignment
    Harmonia.new(store_path).assign(:weeknotes)

    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /is writing the notes this week.$/ }
  end
end