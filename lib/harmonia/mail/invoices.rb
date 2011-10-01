require 'harmonia/mail'
require 'free_agent'

class Harmonia
  class Mail
    class Invoices < Harmonia::Mail
      def send
        selected_person = @assignee
        email_body = render_email('invoices', binding)
        mail = ::Mail.deliver do
          self.charset = "UTF-8"
            from '"Chaos Administrator" <chaos@gofreerange.com>'
              to ENV["TO"] || 'lets@gofreerange.com'
         subject "#{selected_person}, it's your turn to do invoices."
            body email_body
        end
      end

      private

      def overdue_invoices
        domain = ENV["FREEAGENT_DOMAIN"]
        email = ENV["FREEAGENT_EMAIL"]
        password = ENV["FREEAGENT_PASSWORD"]
        freerange = FreeAgent::Company.new(domain, email, password)
        @overdue_invoices ||= freerange.invoices.select { |i| i.status == "Overdue" }
      end
    end
  end
end