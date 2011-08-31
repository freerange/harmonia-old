require "test_helper"

class HarmoniaTest < Test::Unit::TestCase
  def test_eventually_every_one_is_chosen_as_delegate
    delegates = []
    100.times { delegates << Harmonia.invoice_delegate; delegates.uniq! }
    assert_equal ["James A", "James M", "Jase", "Tom", "Chris"].sort, delegates.sort
  end

  def test_sends_mail_to_invoice_delegate
    Harmonia.stubs(:invoice_delegate).returns "James"

    Harmonia.run

    assert_equal 1, Mail::TestMailer.deliveries.length
    assert_equal "James, it's your turn to do invoices.", Mail::TestMailer.deliveries.first.subject
  end
end