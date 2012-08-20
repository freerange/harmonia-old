set :ruby, `which ruby`.strip
set :path, File.expand_path("..", __FILE__)

harmonia_run = %{cd :path && bundle exec :ruby -I:path/lib -rharmonia -e}

job_type :harmonia, %{#{harmonia_run} "Harmonia.new.:task(*:tasks)"}

every :monday, :at => "11.50am" do
  harmonia :unassign, tasks: [:annual_return, :invoices, :weeknotes, :vat_return, :corporation_tax_payment, :corporation_tax_submission, :gardener, :fire_logbook, :wages, :drinks]
end

every :monday, :at => "12:00pm" do
  harmonia :assign, tasks: [:annual_return, :invoices, :weeknotes, :vat_return, :corporation_tax_payment, :corporation_tax_submission]
end

every :wednesday, :at => "12:00pm" do
  harmonia :assign, tasks: [:gardener]
end

every :thursday, :at => "10.00am" do
  harmonia :assign, tasks: [:fire_logbook]
end

every :thursday, :at => "12:00pm" do
  harmonia :remind, tasks: [:weeknotes]
end

# Midday on the 25th of every month
every "0 12 25 * *" do
  harmonia :assign, tasks: [:wages]
end

# Midday on the 1st of every month
every "0 12 1 * *" do
  harmonia :assign, tasks: [:drinks]
end
