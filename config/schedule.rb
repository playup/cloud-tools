# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Learn more: http://github.com/javan/whenever
job_type :cloud_command, "cd :path && :task :output"
set :output, "log/cloud-tools.log"
every 1.day do
  cloud_command "./vol-list -e production -k playup:snapshot -v true --backup"
  cloud_command "./vol-list -e production -k playup:snapshot -v true --delete --age 7"
end