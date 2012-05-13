require 'harmonia/mail'

class Harmonia
  class Mail
    class CorporationTaxPayment < Harmonia::Mail
      def self.timeline
        FreeAgent::Timeline.new(ENV["FREEAGENT_DOMAIN"], ENV["FREEAGENT_API_KEY"])
      end

      def self.required?
        timeline.upcoming_corporation_tax_payments.any?
      end

      def to_mail
        selected_person = @assignee
        due_return = self.class.timeline.upcoming_corporation_tax_payments.first
        email_body = render_email('corporation_tax_payment', binding)
        mail do
          subject "#{selected_person} is paying our Corporation Tax this week."
             body email_body
        end
      end
    end
  end
end

