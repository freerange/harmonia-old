require "tomafro/deploy"

set :application, "harmonia"
set :repository,  "git@github.com:freerange/harmonia.git"

server "gofreerange.com", :app, :db

set :whenever_command, "bundle exec whenever"

require "whenever/capistrano"

def current_path
  deploy_to
end

def release_path
  deploy_to
end