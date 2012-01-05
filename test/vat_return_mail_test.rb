require "test_helper"

class VatReturnMailTest < Test::Unit::TestCase
  def setup
    stub_free_agent_timeline!
    ::Mail::TestMailer.deliveries.clear
  end

  def test_should_not_be_required_if_there_are_no_upcoming_vat_returns
    Timecop.travel(Date.parse("2012-02-26")) do
      assert !Harmonia::Mail::VatReturn.required?
    end
  end

  def test_should_include_summary_of_the_upcoming_vat_return
    Timecop.travel(Date.parse("2012-02-29")) do
      Harmonia::Mail::VatReturn.new("James").send
      assert Mail::TestMailer.deliveries.find { |m| m.body =~ /VAT Return 01 12 Electronic Submission and Payment Due/ }
    end
  end
end