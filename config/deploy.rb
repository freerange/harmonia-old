require "tomafro/deploy"

server "gofreerange.com", :app

set :application, "harmonia"
set :repository,  "git@github.com:freerange/harmonia.git"

set :current_path, deploy_to
set :release_path, deploy_to

require "whenever/capistrano"

set :whenever_command, "bundle exec whenever"
set :whenever_update_flags, "--update-crontab #{whenever_identifier} -s password=#{password}"