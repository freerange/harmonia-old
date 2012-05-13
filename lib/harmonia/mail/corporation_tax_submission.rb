require 'harmonia/mail'

class Harmonia
  class Mail
    class CorporationTaxSubmission < Harmonia::Mail
      def self.timeline
        FreeAgent::Timeline.new(ENV["FREEAGENT_DOMAIN"], ENV["FREEAGENT_API_KEY"])
      end

      def self.required?
        timeline.upcoming_corporation_tax_submissions.any?
      end

      def to_mail
        selected_person = @assignee
        due_return = self.class.timeline.upcoming_corporation_tax_submissions.first
        email_body = render_email('corporation_tax_submission', binding)
        mail do
          subject "#{selected_person} is submitting our Corporation Tax liability this week."
             body email_body
        end
      end
    end
  end
end

