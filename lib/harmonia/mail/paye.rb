require 'harmonia/mail'

class Harmonia
  class Mail
    class Paye < Harmonia::Mail
      def to_mail
        selected_person = @assignee
        email_body = render_email('paye', binding)
        mail do
          subject "#{selected_person}, it's your turn to pay the queen (well, HMRC)."
             body email_body
        end
      end
    end
  end
end

