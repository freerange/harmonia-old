require 'mail'
require 'erb'

Mail.defaults do
  if ENV["ENV"] == "test"
    delivery_method :test
  else
    delivery_method :smtp, { :address              => "smtp.gmail.com",
                             :port                 => 587,
                             :domain               => 'gofreerange.com',
                             :user_name            => 'chaos@gofreerange.com',
                             :password             => ENV["SMTP_PASSWORD"],
                             :authentication       => 'plain',
                             :enable_starttls_auto => true  }
  end
end

class Harmonia
  class Mail
    autoload :Invoices, "harmonia/mail/invoices"
    autoload :Weeknotes, "harmonia/mail/weeknotes"

    def initialize(person)
      @assignee = person
    end

    private

    def render_email(template, b)
      ERB.new(email_template(template), nil, ">").result(b)
    end

    def email_template(name)
      File.read(File.expand_path("../../emails/#{name}.erb", __FILE__))
    end
  end
end
