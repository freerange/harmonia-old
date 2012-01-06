require "free_agent"
require "ri_cal"
require "open-uri"
require "date"

class FreeAgent::Timeline

  class Return
    attr_reader :summary, :due

    def initialize(summary, due)
      @summary = summary
      @due = due
    end

    def due_next_week?
      due.cweek == (Date.today.cweek + 1)
    end
  end

  def self.load_ical_data(company, api_key)
    open("https://#{company}.freeagent.com/company/tax_timeline.ics?key=#{api_key}").read
  end

  def initialize(company, api_key)
    ical = RiCal.parse_string(self.class.load_ical_data(company, api_key))[0]
    @events = ical.events
  end

  def vat_returns
    @events.select { |e| e.summary =~ /VAT Return/ }.map do |c|
      Return.new(c.summary, c.dtstart)
    end
  end

  def upcoming_vat_returns
    vat_returns.select { |vr| vr.due_next_week? }
  end

  def annual_returns
    @events.select { |e| e.summary =~ /Annual Return/ }.map do |c|
      Return.new(c.summary, c.dtstart)
    end
  end

  def upcoming_annual_returns
    annual_returns.select { |ar| ar.due_next_week? }
  end

  def corporation_tax_payments
    @events.select { |e| e.summary =~ /(Corporation Tax)(.+)(Payment Due)/ }.map do |c|
      Return.new(c.summary, c.dtstart)
    end
  end

  def upcoming_corporation_tax_payments
    corporation_tax_payments.select { |ct| ct.due_next_week? }
  end
end