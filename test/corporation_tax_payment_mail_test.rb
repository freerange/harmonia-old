require "test_helper"

class CorporationTaxPaymentMailTest < Test::Unit::TestCase
  def setup
    stub_free_agent_timeline!
    ::Mail::TestMailer.deliveries.clear
  end

  def test_should_not_be_required_if_there_are_no_upcoming_corporation_tax_payments
    Timecop.travel(Date.parse("2012-10-15")) do
      assert !Harmonia::Mail::CorporationTaxPayment.required?
    end
  end

  def test_should_include_summary_of_the_upcoming_corporation_tax_payments
    Timecop.travel(Date.parse("2012-10-22")) do
      Harmonia::Mail::CorporationTaxPayment.new("James").send
      assert Mail::TestMailer.deliveries.find { |m| m.body =~ /Corporation Tax\, year ending 31 Jan 12 Payment Due/ }
    end
  end
end