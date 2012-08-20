require 'harmonia/mail'

class Harmonia
  class Mail
    class HarmoniaTest < Harmonia::Mail
      def to_mail
        selected_person = @assignee
        mail do
          subject "Please ignore. This is a test email from Harmonia."
             body <<-EOF
This is a test email that you can use to test that everything's hooked up properly in your deployment.

For info only, the assignee of this 'task' is #{selected_person}.
              EOF
        end
      end
    end
  end
end

