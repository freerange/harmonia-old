# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :ruby, `which ruby`.strip
set :path, File.expand_path("../lib", __FILE__)

job_type :harmonia, %{PASSWORD=:password TO=james@lazyatom.com :ruby -I:path -rharmonia -e "Harmonia.run"}

every 1.minutes do
  harmonia "x"
end