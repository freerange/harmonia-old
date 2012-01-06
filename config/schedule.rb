set :ruby, `which ruby`.strip
set :path, File.expand_path("..", __FILE__)

harmonia_run = %{cd :path && bundle exec :ruby -I:path/lib -rharmonia -e}
job_type :assign,   %{#{harmonia_run} "Harmonia.new.assign(::task)"}
job_type :unassign, %{#{harmonia_run} "Harmonia.new.unassign(::task)"}
job_type :remind,   %{#{harmonia_run} "Harmonia.new.remind(::task)"}

every :monday, :at => "11.59am" do
  unassign :invoices
  unassign :weeknotes
  unassign :fire_logbook
  unassign :wages
  unassign :vat_return
  unassign :annual_return
end

every :monday, :at => "12:00pm" do
  assign :invoices
  assign :weeknotes
  assign :vat_return
  assign :annual_return
end

every :thursday, :at => "10.00am" do
  assign :fire_logbook
end

every :thursday, :at => "12:00pm" do
  remind :weeknotes
end

every "0 12 25 * *" do
  assign :wages
end