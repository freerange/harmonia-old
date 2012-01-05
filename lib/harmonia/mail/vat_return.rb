require 'harmonia/mail'

class Harmonia
  class Mail
    class VatReturn < Harmonia::Mail
      def self.timeline
        FreeAgent::Timeline.new(ENV["FREEAGENT_DOMAIN"], ENV["FREEAGENT_API_KEY"])
      end

      def self.required?
        timeline.upcoming_vat_returns.any?
      end

      def to_mail
        selected_person = @assignee
        due_return = self.class.timeline.upcoming_vat_returns.first
        email_body = render_email('vat_return', binding)
        mail = ::Mail.new do
        self.charset = "UTF-8"
           from '"Chaos Administrator" <chaos@gofreerange.com>'
             to ENV["TO"] || 'lets@gofreerange.com'
        subject "#{selected_person} is submitting the VAT return this week."
           body email_body
        end
      end
    end
  end
end

