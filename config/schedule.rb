set :ruby, `which ruby`.strip
set :path, File.expand_path("..", __FILE__)

harmonia_run = %{cd :path && bundle exec :ruby -I:path/lib -rharmonia -e}

job_type :harmonia, %{#{harmonia_run} "Harmonia.new.:task(*:tasks)"}

# Test task that we can use to test that the full stack is working correctly
# See harmonia_test.rb for more information
# every 3.minutes do
#   harmonia :assign, tasks: [:harmonia_test]
# end

every :monday, :at => "11.50am" do
  harmonia :unassign, tasks: [:annual_return, :invoices, :weeknotes, :vat_return, :corporation_tax_payment, :corporation_tax_submission, :gardener, :fire_logbook, :wages, :drinks, :paye]
end

every :monday, :at => "12:00pm" do
  harmonia :assign, tasks: [:annual_return, :vat_return, :corporation_tax_payment, :corporation_tax_submission]
end