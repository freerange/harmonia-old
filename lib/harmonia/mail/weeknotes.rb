require 'harmonia/mail'

class Harmonia
  class Mail
    class Weeknotes < Harmonia::Mail
      def send
        selected_person = @assignee
        email_body = render_email('weeknotes', binding)
        mail = ::Mail.deliver do
          self.charset = "UTF-8"
            from '"Chaos Administrator" <chaos@gofreerange.com>'
              to ENV["TO"] || 'lets@gofreerange.com'
         subject "#{selected_person} is writing the notes this week."
            body email_body
        end
      end
    end
  end
end