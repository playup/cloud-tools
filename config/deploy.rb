require 'rubygems'
require "bundler/capistrano"
require "rvm/capistrano"
require "whenever/capistrano"
set :application, "cloud-tools"
set :repository,  "https://github.com/playup/cloud-tools"
set :user, 'root'

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names

set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "enabled"       # more info: rvm help autolibs
set :rvm_type, :system
set :whenever_roles, [:app]

before 'deploy:setup', 'rvm:install_rvm'  # install RVM
before 'deploy:setup', 'rvm:install_ruby' 
# after "deploy", "rvm:trust_rvmrc"


role :web, "50.112.105.89"                          # This may be the same as your `Web` server
role :app, "50.112.105.89"                          # This may be the same as your `Web` server

ssh_options[:keys] = [File.join(ENV["HOME"], ".dew/accounts/keys/production/us-west-2/aws/AWS_us_west_2.pem")]




# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end