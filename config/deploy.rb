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
after 'deploy:setup', 'aws:configure' 
after "deploy:update", "aws:symlink"


role :web, "50.112.105.89"                          # This may be the same as your `Web` server
role :app, "50.112.105.89"                          # This may be the same as your `Web` server

ssh_options[:keys] = [File.join(ENV["HOME"], ".dew/accounts/keys/production/us-west-2/aws/AWS_us_west_2.pem")]


set :rvm_ruby_string, 'ruby-2.0.0-latest@cloud-getter'


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

	namespace :rvm do
	  task :trust_rvmrc do
	    run "rvm rvmrc trust #{release_path}"
	  end
	end

	namespace :aws do
	  desc "Create database yaml in shared path"
	  task :configure do
	    set :aws_access_key do
	      Capistrano::CLI.password_prompt "AWS Access Key: "
	    end
	 
	    set :aws_region do
	      "us-west-2"
	    end

	    set :aws_secret_access_key do
	      Capistrano::CLI.password_prompt "AWS Secret Access Key:"
	    end
	 
	    aws_config = <<-EOF
	      production:
	        aws_access_key_id: #{aws_access_key}
	        aws_secret_access_key: #{aws_secret_access_key}
	        region: #{aws_region}
	    EOF
	 
	    run "mkdir -p #{shared_path}/config"
	    put aws_config, "#{shared_path}/config/config.yml"
	  end

	  desc "Make symlink for config yaml"
	  task :symlink do
	    run "ln -nfs #{shared_path}/config/config.yml #{latest_release}/config/config.yml"
	  end
	
end