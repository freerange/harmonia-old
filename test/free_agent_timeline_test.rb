# encoding: UTF-8
require "test_helper"

class FreeAgentTimelineTest < Test::Unit::TestCase
  def setup
    stub_free_agent_timeline!
  end

  def test_should_parse_vat_return_due_dates_from_feed
    timeline = FreeAgent::Timeline.new("freerange", "api-key")
    vat_returns = timeline.vat_returns
    assert_equal 1, vat_returns.length
    next_vat_return = vat_returns.first
    assert_equal "VAT Return 01 12 Electronic Submission and Payment Due £23,769.28", next_vat_return.summary
    assert_equal Date.parse("2012-03-07"), next_vat_return.due
  end

  def test_should_return_no_upcoming_vat_reminders_if_none_are_due_next_week
    Timecop.travel(Date.parse("2012-02-26")) do
      timeline = FreeAgent::Timeline.new("freerange", "api-key")
      assert timeline.upcoming_vat_returns.empty?
    end
  end

  def test_should_return_any_upcoming_vat_reminders_if_some_are_due_next_week
    Timecop.travel(Date.parse("2012-02-27")) do
      timeline = FreeAgent::Timeline.new("freerange", "api-key")
      assert timeline.upcoming_vat_returns.any?
    end
  end

  def test_should_parse_annual_return_due_dates_from_feed
    timeline = FreeAgent::Timeline.new("freerange", "api-key")
    annual_returns = timeline.annual_returns
    assert_equal 3, annual_returns.length
    next_annual_return = annual_returns.first
    assert_equal "Annual Return as at 01-01-2012 Companies House Annual Return Due", next_annual_return.summary.strip
    assert_equal Date.parse("2012-01-29"), next_annual_return.due
  end

  def test_should_return_no_upcoming_annual_reminders_if_none_are_due_next_week
    Timecop.travel(Date.parse("2012-01-09")) do
      timeline = FreeAgent::Timeline.new("freerange", "api-key")
      assert timeline.upcoming_annual_returns.empty?
    end
  end

  def test_should_return_any_upcoming_annual_return_reminders_if_some_are_due_next_week
    Timecop.travel(Date.parse("2012-01-16")) do
      timeline = FreeAgent::Timeline.new("freerange", "api-key")
      assert timeline.upcoming_annual_returns.any?
    end
  end
end