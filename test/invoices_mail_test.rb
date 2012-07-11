require "test_helper"

class InvoicesMailTest < Test::Unit::TestCase
  def setup
    ::Mail::TestMailer.deliveries.clear
    @mail = Harmonia::Mail::Invoices.new("James")
  end

  def test_sends_mail_to_invoice_delegate
    @mail.stubs(:overdue_invoices).returns([])
    @mail.stubs(:overdue_bills).returns([])

    @mail.send

    assert Mail::TestMailer.deliveries.find { |m| m.subject == "James, it's your turn to do invoices." }
  end

  def test_doesnt_mention_overdue_invoices_if_there_werent_any
    stub_free_agent!([], [])

    @mail.send
    assert_no_match /You should also chase up the following invoices which are overdue/, Mail::TestMailer.deliveries.first.body.to_s
  end

  def test_correctly_displays_urls_for_overdue_invoices
    overdue_invoices = [
      stub('invoice-A', reference: "INVOICE-A", net_value: 1, due_on: Date.today, url: 'http://example.com/invoice/A'),
      stub('invoice-B', reference: "INVOICE-B", net_value: 1, due_on: Date.today, url: 'http://example.com/invoice/B')
    ]
    @mail.stubs(:overdue_invoices).returns(overdue_invoices)
    @mail.stubs(:overdue_bills).returns([])

    assert_match /\shttp:\/\/example\.com\/invoice\/A\s/, @mail.to_mail.body.to_s
  end
end
