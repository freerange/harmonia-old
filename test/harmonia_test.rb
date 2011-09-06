require "test_helper"

class HarmoniaTest < Test::Unit::TestCase
  def setup
    Mail::TestMailer.deliveries.clear
  end

  def test_eventually_every_one_is_chosen_as_invoice_delegate
    delegates = []
    100.times { delegates << Harmonia.new.invoice_delegate; delegates.uniq! }
    assert_equal ["James A", "James M", "Jase", "Tom", "Chris"].sort, delegates.sort
  end

  def test_eventually_every_one_is_chosen_as_weeknotes_delegate
    delegates = []
    100.times { delegates << Harmonia.new.weeknotes_delegate; delegates.uniq! }
    assert_equal ["James A", "James M", "Jase", "Tom", "Chris"].sort, delegates.sort
  end

  def test_weeknotes_delegate_is_never_the_same_as_invoice_delegate
    harmonia = Harmonia.new
    same = false
    100.times do
      same = same || (harmonia.invoice_delegate == harmonia.weeknotes_delegate)
      break if same
    end
    assert !same, "nobody should be delegated both weeknotes and invoices"
  end

  def test_sends_mail_to_invoice_delegate
    Harmonia.any_instance.stubs(:overdue_invoices).returns([])
    Harmonia.any_instance.stubs(:invoice_delegate).returns "James"

    Harmonia.run

    assert Mail::TestMailer.deliveries.find { |m| m.subject == "James, it's your turn to do invoices." }
  end

  def test_sends_mail_to_weeknotes_delegate
    Harmonia.any_instance.stubs(:overdue_invoices).returns([])
    Harmonia.any_instance.stubs(:weeknotes_delegate).returns "Tom"

    Harmonia.run

    assert Mail::TestMailer.deliveries.find { |m| m.subject == "Tom is writing the notes this week." }
  end

  def test_doesnt_mention_overdue_invoices_if_there_werent_any
    harmonia = Harmonia.new
    harmonia.stubs(:free_agent_config).returns(:domain => "x", :username => "y", :password => "z")
    invoices = []
    FreeAgent::Company.stubs(:new).returns(stub('company', :invoices => invoices))

    harmonia.send_invoice_email
    assert_no_match /You should also chase up the following invoices which are overdue/, Mail::TestMailer.deliveries.first.body.to_s
  end
end