require 'harmonia/mail'

class Harmonia
  class Mail
    class Weeknotes < Harmonia::Mail
      def to_mail
        selected_person = @assignee
        email_body = render_email('weeknotes', binding)
        mail do
          subject "#{selected_person} is writing the notes this week."
             body email_body
        end
      end

      def send_reminder
        selected_person = @assignee
        email_body = render_email('weeknotes', binding)
        m = mail do
          subject "#{selected_person}, don't forget the weeknotes."
             body email_body
        end
        m.deliver
      end
    end
  end
end