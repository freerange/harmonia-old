require 'harmonia/mail'

class Harmonia
  class Mail
    class AnnualReturn < Harmonia::Mail
      def self.timeline
        FreeAgent::Timeline.new(ENV["FREEAGENT_DOMAIN"], ENV["FREEAGENT_API_KEY"])
      end

      def self.required?
        timeline.upcoming_annual_returns.any?
      end

      def to_mail
        selected_person = @assignee
        due_return = self.class.timeline.upcoming_annual_returns.first
        email_body = render_email('annual_return', binding)
        mail do
          self.charset = "UTF-8"
             from '"Chaos Administrator" <chaos@gofreerange.com>'
               to ENV["TO"] || 'lets@gofreerange.com'
          subject "#{selected_person} is submitting the Annual Return this week."
             body email_body
        end
      end
    end
  end
end

