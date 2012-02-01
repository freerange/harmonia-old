require "test_helper"

class HarmoniaTest < Test::Unit::TestCase
  def setup
    ::Mail::TestMailer.deliveries.clear
    ENV["HARMONIA_PEOPLE"] = "Tom, Dick, Harry"
    @harmonia = Harmonia.new(store_path)
  end

  def test_sends_mail_to_invoices_assignee_after_assignment
    overdue_invoice = stub("invoice", :status => "Overdue", :reference => "WEM-001", :net_value => BigDecimal.new(100), :due_on => "2012-02-26 00:00:00 UTC", :url => "http://example.com/invoice/WEM-001")
    overdue_bill = stub("bill", :status => "Overdue", :reference => "FOO-999", :total_value => BigDecimal.new(50), :due_date => "2012-02-27 00:00:00 UTC")
    stub_free_agent!([overdue_invoice], [overdue_bill])
    @harmonia.assign(:invoices)

    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /it's your turn to do invoices.$/ }
  end

  def test_sends_mail_to_weeknotes_assignee_after_assignment
    @harmonia.assign(:weeknotes)

    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /is writing the notes this week.$/ }
  end

  def test_sends_mail_to_vat_return_assignee_after_assignment
    stub_free_agent_timeline!
    Timecop.travel(Date.parse("2012-02-29")) do
      @harmonia.assign(:vat_return)
    end

    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /is submitting the VAT return this week.$/ }
  end

  def test_should_not_send_email_if_no_vat_return_is_due_soon
    Harmonia::Mail::VatReturn.stubs(:required?).returns(false)
    @harmonia.assign(:vat_return)

    assert Mail::TestMailer.deliveries.empty?
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

  def test_sends_mail_to_wages_assignee_after_assignment
    @harmonia.assign(:wages)

    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /it's your turn to pay us some monies.$/ }
  end

  def test_sends_mail_to_annual_return_assignee_after_assignment
    stub_free_agent_timeline!
    Timecop.travel(Date.parse("2012-01-16")) do
      @harmonia.assign(:annual_return)
    end

    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /is submitting the Annual Return this week.$/ }
  end

  def test_should_not_send_email_if_no_vat_return_is_due_soon
    Harmonia::Mail::AnnualReturn.stubs(:required?).returns(false)
    @harmonia.assign(:annual_return)

    assert Mail::TestMailer.deliveries.empty?
  end

  def test_sends_mail_to_corp_tax_payment_assignee_after_assignment
    stub_free_agent_timeline!
    Timecop.travel(Date.parse("2012-10-22")) do
      @harmonia.assign(:corporation_tax_payment)
    end

    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /is paying our Corporation Tax this week.$/ }
  end

  def test_should_not_send_email_if_no_corp_tax_payment_is_due_soon
    Harmonia::Mail::CorporationTaxPayment.stubs(:required?).returns(false)
    @harmonia.assign(:corporation_tax_payment)

    assert Mail::TestMailer.deliveries.empty?
  end

  def test_sends_mail_to_corp_tax_payment_assignee_after_assignment
    stub_free_agent_timeline!
    Timecop.travel(Date.parse("2012-01-23")) do
      @harmonia.assign(:corporation_tax_submission)
    end

    assert Mail::TestMailer.deliveries.find { |m| m.subject =~ /is submitting our Corporation Tax liability this week.$/ }
  end

  def test_should_not_send_email_if_no_corp_tax_payment_is_due_soon
    Harmonia::Mail::CorporationTaxSubmission.stubs(:required?).returns(false)
    @harmonia.assign(:corporation_tax_submission)

    assert Mail::TestMailer.deliveries.empty?
  end

  def test_raises_exception_if_task_is_unknown
    e = assert_raises(RuntimeError) { @harmonia.assign(:gobbledegook) }
    assert_equal "Task gobbledegook isn't known to harmonia", e.message
  end
end