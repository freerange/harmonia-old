require "test_helper"

class HarmoniaTest < Test::Unit::TestCase
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
    Harmonia.any_instance.stubs(:invoice_delegate).returns "James"

    Harmonia.run

    assert_equal 1, Mail::TestMailer.deliveries.length
    assert_equal "James, it's your turn to do invoices.", Mail::TestMailer.deliveries.first.subject
  end
end