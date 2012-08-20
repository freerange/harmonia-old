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
    autoload :FireLogbook, "harmonia/mail/fire_logbook"
    autoload :Wages, "harmonia/mail/wages"
    autoload :VatReturn, "harmonia/mail/vat_return"
    autoload :AnnualReturn, "harmonia/mail/annual_return"
    autoload :CorporationTaxPayment, "harmonia/mail/corporation_tax_payment"
    autoload :CorporationTaxSubmission, "harmonia/mail/corporation_tax_submission"
    autoload :Gardener, "harmonia/mail/gardener"
    autoload :Drinks, "harmonia/mail/drinks"
    autoload :HarmoniaTest, "harmonia/mail/harmonia_test"

    def self.build(task, *args)
      klass = task.to_s.split("_").map(&:capitalize).join
      const_get(klass).new(*args)
    end

    def initialize(person)
      @assignee = person
    end

    def mail(&block)
      mail = ::Mail.new(&block)
      mail.charset = "UTF-8"
      mail.reply_to ENV["REPLY_TO"] || "everyone@gofreerange.com"
      mail.to ENV["TO"] || "everyone@gofreerange.com"
      mail.from ENV["FROM"] || '"Chaos Administrator" <chaos@gofreerange.com>'
      mail
    end

    def send
      to_mail.deliver
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
