# encoding: UTF-8
ENV["ENV"] = "test"
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "harmonia"
require "test/unit"
require "mocha"
require "harmonia/mail"
require "stringio"
require "timecop"

class Test::Unit::TestCase
  private

  def store_path
    tmp_dir = File.expand_path("../../tmp", __FILE__)
    FileUtils.mkdir_p(tmp_dir)
    File.join(tmp_dir, "harmonia.yml")
  end

  def stub_free_agent!(invoices)
    Harmonia::Mail::Invoices.any_instance.stubs(:free_agent_config).returns({})
    FreeAgent::Company.stubs(:new).returns(stub('company', :invoices => invoices))
  end

  def stub_free_agent_timeline!
    FreeAgent::Timeline.stubs(:load_ical_data).returns(sample_free_agent_ical_data)
  end

  def sample_free_agent_ical_data
    data = <<-EOS
BEGIN:VCALENDAR
X-WR-CALDESC:Tax Timeline for Go Free Range Ltd courtesy of FreeAgent
X-WR-CALNAME:Go Free Range Ltd Tax Timeline
X-WR-TIMEZONE:UTC
CALSCALE:GREGORIAN
PRODID:iCalendar-Ruby
VERSION:2.0
BEGIN:VEVENT
DTEND:20120120
DTSTAMP:20120105T163517
DTSTART:20120119
SEQUENCE:0
SUMMARY:5 Payslips PAYE/NI Payment Due £0.00
UID:2012-01-05T16:35:17+00:00_320405808@web3.production.freeagentcentral.ne
 t
END:VEVENT
BEGIN:VEVENT
DTEND:20120130
DTSTAMP:20120105T163517
DTSTART:20120129
SEQUENCE:0
SUMMARY:Annual Return as at 01-01-2012 Companies House Annual Return Due 
UID:2012-01-05T16:35:17+00:00_279689095@web3.production.freeagentcentral.ne
 t
END:VEVENT
BEGIN:VEVENT
DTEND:20120201
DTSTAMP:20120105T163517
DTSTART:20120131
SEQUENCE:0
SUMMARY:Corporation Tax\, year ending 31 Jan 11 Submission Due 
UID:2012-01-05T16:35:17+00:00_23877742@web3.production.freeagentcentral.net
END:VEVENT
BEGIN:VEVENT
DTEND:20120308
DTSTAMP:20120105T163517
DTSTART:20120307
SEQUENCE:0
SUMMARY:VAT Return 01 12 Electronic Submission and Payment Due £23\,769.28
UID:2012-01-05T16:35:17+00:00_739323188@web3.production.freeagentcentral.ne
 t
END:VEVENT
BEGIN:VEVENT
DTEND:20121101
DTSTAMP:20120105T163517
DTSTART:20121031
SEQUENCE:0
SUMMARY:Accounting Period Ending 31-01-2012 Companies House Accounts Due 
UID:2012-01-05T16:35:17+00:00_16480627@web3.production.freeagentcentral.net
END:VEVENT
BEGIN:VEVENT
DTEND:20121102
DTSTAMP:20120105T163517
DTSTART:20121101
SEQUENCE:0
SUMMARY:Corporation Tax\, year ending 31 Jan 12 Payment Due £70\,635.61
UID:2012-01-05T16:35:17+00:00_716599372@web3.production.freeagentcentral.ne
 t
END:VEVENT
BEGIN:VEVENT
DTEND:20130130
DTSTAMP:20120105T163517
DTSTART:20130129
SEQUENCE:0
SUMMARY:Annual Return as at 01-01-2013 Companies House Annual Return Due 
UID:2012-01-05T16:35:17+00:00_495769066@web3.production.freeagentcentral.ne
 t
END:VEVENT
BEGIN:VEVENT
DTEND:20130201
DTSTAMP:20120105T163517
DTSTART:20130131
SEQUENCE:0
SUMMARY:Corporation Tax\, year ending 31 Jan 12 Submission Due 
UID:2012-01-05T16:35:17+00:00_603207369@web3.production.freeagentcentral.ne
 t
END:VEVENT
BEGIN:VEVENT
DTEND:20140130
DTSTAMP:20120105T163517
DTSTART:20140129
SEQUENCE:0
SUMMARY:Annual Return as at 01-01-2014 Companies House Annual Return Due 
UID:2012-01-05T16:35:17+00:00_702869530@web3.production.freeagentcentral.ne
 t
END:VEVENT
END:VCALENDAR
    EOS
    data.strip
  end
end