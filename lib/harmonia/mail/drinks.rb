require 'harmonia/mail'

class Harmonia
  class Mail
    class Drinks < Harmonia::Mail
      def to_mail
        selected_person = @assignee
        email_body = render_email('drinks', binding)
        mail do
          subject "#{selected_person}, it's your turn to organise drinks."
             body email_body
        end
      end
    end
  end
end
