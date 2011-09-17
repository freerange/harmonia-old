require 'harmonia/mail'
require 'yaml'
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

      def free_agent_config
        config = YAML.load(File.open(File.expand_path("../../config/free_agent.yml", __FILE__)))
      end

      def overdue_invoices
        config = free_agent_config
        freerange = FreeAgent::Company.new(config[:domain], config[:username], config[:password])
        @overdue_invoices ||= freerange.invoices.select { |i| i.status == "Overdue" }
      end
    end
  end
end