require "test_helper"

class HarmoniaTest < Test::Unit::TestCase
  def setup
    ::Mail::TestMailer.deliveries.clear
    ENV["HARMONIA_PEOPLE"] = "Tom, Dick, Harry"
    @harmonia = Harmonia.new(store_path)
  end

  def test_sends_mail_to_invoices_assignee_after_assignment
    stub_free_agent!([])
    @harmonia.assign(:invoices)

    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /it's your turn to do invoices.$/ }
  end

  def test_sends_mail_to_weeknotes_assignee_after_assignment
    @harmonia.assign(:weeknotes)

    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /is writing the notes this week.$/ }
  end

  def test_reminds_assigned_user_about_weeknotes
    @harmonia.assign(:weeknotes)
    assignee = Mail::TestMailer.deliveries.first.subject.match(/^([\w\s]+) is writing/)[1]
    ::Mail::TestMailer.deliveries.clear
    @harmonia.remind(:weeknotes)
    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /#{assignee}, don't forget the weeknotes.$/ }
  end

  def test_sends_mail_to_fire_logbook_assignee_after_assignment
    @harmonia.assign(:fire_logbook)

    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /it's your turn to update the Fire Logbook today.$/ }
  end

  def test_raises_exception_if_task_is_unknown
    e = assert_raises(RuntimeError) { @harmonia.assign(:gobbledegook) }
    assert_equal "Task gobbledegook isn't known to harmonia", e.message
  end
end