require "test_helper"

class AnnualReturnMailTest < Test::Unit::TestCase
  def setup
    stub_free_agent_timeline!
    ::Mail::TestMailer.deliveries.clear
  end

  def test_should_not_be_required_if_there_are_no_upcoming_vat_returns
    Timecop.travel(Date.parse("2012-01-09")) do
      assert !Harmonia::Mail::AnnualReturn.required?
    end
  end

  def test_should_include_summary_of_the_upcoming_vat_return
    Timecop.travel(Date.parse("2012-01-16")) do
      Harmonia::Mail::AnnualReturn.new("James").send
      assert Mail::TestMailer.deliveries.find { |m| m.body =~ /Annual Return as at 01-01-2012 Companies House Annual Return Due/ }
    end
  end
end