require 'harmonia/mail'

class Harmonia
  class Mail
    class Gardener < Harmonia::Mail
      def to_mail
        selected_person = @assignee
        email_body = render_email('gardener', binding)
        mail do
          subject "#{selected_person}, it's your turn to water the plants."
             body email_body
        end
      end
    end
  end
end