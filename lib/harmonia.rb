#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'mail'
require 'free_agent'
require 'erb'

Mail.defaults do
  if ENV["ENV"] == "test"
    delivery_method :test
  else
    delivery_method :smtp, { :address              => "smtp.gmail.com",
                             :port                 => 587,
                             :domain               => 'gofreerange.com',
                             :user_name            => 'chaos@gofreerange.com',
                             :password             => ENV["PASSWORD"],
                             :authentication       => 'plain',
                             :enable_starttls_auto => true  }
  end
end

class Harmonia
  PEOPLE = ["James A", "James M", "Tom", "Chris", "Jase"]

  def invoice_delegate
    @invoice_delegate ||= PEOPLE[rand(PEOPLE.length)]
  end

  def weeknotes_delegate
    remaining_candidates = PEOPLE - [invoice_delegate]
    @weeknotes_delegate ||= remaining_candidates[rand(remaining_candidates.length)]
  end

  def free_agent_config
    config = YAML.load(File.open(File.expand_path("../../config/free_agent.yml", __FILE__)))
  end

  def overdue_invoices
    config = free_agent_config
    freerange = FreeAgent::Company.new(config[:domain], config[:username], config[:password])
    @overdue_invoices ||= freerange.invoices.select { |i| i.status == "Overdue" }
  end

  def list_of_overdue_invoices
    io = StringIO.new
    overdue_invoices.each_with_index do |invoice, index|
      io.puts "* '#{invoice.reference}' for £#{"%0.2f" % invoice.net_value} was due on #{invoice.due_on.to_date.to_s(:rfc822)} [#{index+1}]"
    end
    io.puts
    overdue_invoices.each_with_index do |invoice, index|
      io.puts "[#{index+1}] #{invoice.url}"
    end
    io.rewind
    io.read
  end

  def send_invoice_email
    selected_person = invoice_delegate
    overdue_invoices = list_of_overdue_invoices
    email_body = render_email('invoice', binding)
    mail = Mail.deliver do
        from '"Chaos Administrator" <chaos@gofreerange.com>'
          to ENV["TO"] || 'lets@gofreerange.com'
     subject "#{selected_person}, it's your turn to do invoices."
        body email_body
    end
  end

  def send_weeknotes_email
    selected_person = weeknotes_delegate
    email_body = render_email('weeknotes', binding)
    mail = Mail.deliver do
        from '"Chaos Administrator" <chaos@gofreerange.com>'
          to ENV["TO"] || 'lets@gofreerange.com'
     subject "#{selected_person} is writing the notes this week."
        body email_body
    end
  end

  def render_email(template, b)
    ERB.new(email_template(template)).result(b)
  end

  def email_template(name)
    File.read(File.expand_path("../emails/#{name}.erb", __FILE__))
  end

  def self.run
    instance = new
    instance.send_invoice_email
    instance.send_weeknotes_email
  end
end