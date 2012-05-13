require 'harmonia/mail'

class Harmonia
  class Mail
    class Wages < Harmonia::Mail
      def to_mail
        selected_person = @assignee
        email_body = render_email('wages', binding)
        mail do
          self.charset = "UTF-8"
             from '"Chaos Administrator" <chaos@gofreerange.com>'
               to ENV["TO"] || 'lets@gofreerange.com'
          subject "#{selected_person}, it's your turn to pay us some monies."
             body email_body
        end
      end
    end
  end
end

