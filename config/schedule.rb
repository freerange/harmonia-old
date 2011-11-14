set :ruby, `which ruby`.strip
set :path, File.expand_path("..", __FILE__)

harmonia_run = %{cd :path && bundle exec :ruby -I:path/lib -rharmonia -e}
job_type :assign,   %{#{harmonia_run} "Harmonia.new.assign(::task)"}
job_type :unassign, %{#{harmonia_run} "Harmonia.new.unassign(::task)"}
job_type :remind,   %{#{harmonia_run} "Harmonia.new.remind(::task)"}

every :monday, :at => "11.59am" do
  unassign :invoices
  unassign :weeknotes
end

every :monday, :at => "12:00pm" do
  assign :invoices
  assign :weeknotes
end

every :thursday, :at => "12:00pm" do
  remind :weeknotes
end

# # noon on the 1st of March, June, September and December, regardless of weekday
# every '0 12 1 2,5,8,11 *' do
#   assign :vat_return
# end
# 
# # noon on the 7th of March, June, September and December, regardless of weekday
# every '0 12 7 2,5,8,11 *' do
#   remind :vat_return
# end
# 
# # 1pm on the 7th of March, June, September and December, regardless of weekday
# every '0 13 7 2,5,8,11 *' do
#   unassign :vat_return
# end