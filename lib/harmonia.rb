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
  def self.invoice_delegate
    people = ["James A", "James M", "Tom", "Chris", "Jase"]

    selected_person = people[rand(people.length)]
  end

  def self.send_invoice_email(selected_person)
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

  def self.run
    send_invoice_email(invoice_delegate)
  end
end