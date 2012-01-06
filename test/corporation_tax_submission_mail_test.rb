require "test_helper"

class CorporationTaxSubmissionMailTest < Test::Unit::TestCase
  def setup
    stub_free_agent_timeline!
    ::Mail::TestMailer.deliveries.clear
  end

  def test_should_not_be_required_if_there_are_no_upcoming_corporation_tax_returns
    Timecop.travel(Date.parse("2012-01-16")) do
      assert !Harmonia::Mail::CorporationTaxSubmission.required?
    end
  end

  def test_should_include_summary_of_the_upcoming_corporation_tax_returns
    Timecop.travel(Date.parse("2012-01-23")) do
      Harmonia::Mail::CorporationTaxSubmission.new("James").send
      assert Mail::TestMailer.deliveries.find { |m| m.body =~ /Corporation Tax\, year ending 31 Jan 11 Submission Due/ }
    end
  end
end