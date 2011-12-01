require 'harmonia/mail'

class Harmonia
  class Mail
    class FireLogbook < Harmonia::Mail
      def to_mail
        selected_person = @assignee
        email_body = render_email('fire_logbook', binding)
        mail = ::Mail.new do
          self.charset = "UTF-8"
            from '"Chaos Administrator" <chaos@gofreerange.com>'
              to ENV["TO"] || 'lets@gofreerange.com'
         subject "#{selected_person}, it's your turn to update the Fire Logbook today."
            body email_body
        end
      end
    end
  end
end