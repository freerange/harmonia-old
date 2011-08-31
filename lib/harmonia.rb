require 'rubygems'
require 'mail'

people = ["James A", "James M", "Tom", "Chris", "Jase"]

selected_person = people[rand(people.length)]

Mail.defaults do
  delivery_method :smtp, { :address              => "smtp.gmail.com",
                           :port                 => 587,
                           :domain               => 'gofreerange.com',
                           :user_name            => 'chaos@gofreerange.com',
                           :password             => ENV["PASSWORD"],
                           :authentication       => 'plain',
                           :enable_starttls_auto => true  }
end

mail = Mail.deliver do
    from '"Chaos Administrator" <chaos@gofreerange.com>'
      to 'lets@gofreerange.com'
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