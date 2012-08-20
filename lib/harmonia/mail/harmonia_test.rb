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

## Using this test

* As the Harmonia user on the server, enable the code in schedule.rb that runs this task every 3 minutes.

* From your development machine, run `cap whenever:update_crontab`.

* Observe that you receive the test email every 3 minutes.

* As the Harmonia user on the server, disable the code in schedule.rb that runs this task every 3 minutes.  A `git checkout .` should do it.

* From your development machine, run `cap whenever:update_crontab`.

* Finally, as the Harmonia user on the server remove any assignment for this task by running `cd /home/harmonia/app && ruby -Ilib -rharmonia -e "Harmonia.new.unassign(:harmonia_test)"`.
              EOF
        end
      end
    end
  end
end

