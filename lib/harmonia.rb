#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'mail'

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

  def send_invoice_email
    selected_person = invoice_delegate
    mail = Mail.deliver do
        from '"Chaos Administrator" <chaos@gofreerange.com>'
          to ENV["TO"] || 'lets@gofreerange.com'
     subject "#{selected_person}, it's your turn to do invoices."
        body <<-EOS
Greetings Free Range!

It's me, the CHAOS ADMINISTRATOR. I'm here to keep bid'ness ticking over.

Invoices are due, and you, #{selected_person}, have been randomly selected to make sure they get processed this week. Lucky you!

You don't need to drop everything, but try to make sure you get it done this week. We're counting on you!

All the best,

Chaos Administrator
    EOS
    end
  end

  def send_weeknotes_email
    selected_person = weeknotes_delegate
    mail = Mail.deliver do
        from '"Chaos Administrator" <chaos@gofreerange.com>'
          to ENV["TO"] || 'lets@gofreerange.com'
     subject "#{selected_person} is writing the notes this week."
        body <<-EOS
Greetings Free Range!

It's me, the CHAOS ADMINISTRATOR. I'm here to keep bid'ness ticking over.

#{selected_person}, you've been chosen to write the weeknotes. Start gathering as soon as you like; you'll be publishing them on Friday.

All the best,

Chaos Administrator
    EOS
    end
  end

  def self.run
    instance = new
    instance.send_invoice_email
    instance.send_weeknotes_email
  end
end