require "free_agent"
require "ri_cal"
require "open-uri"
require "date"

class FreeAgent::Timeline
  class VatReturn
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
      VatReturn.new(c.summary, c.dtstart)
    end
  end

  def upcoming_vat_returns
    vat_returns.select { |vr| vr.due_next_week? }
  end
end