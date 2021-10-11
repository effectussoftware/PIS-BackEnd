#
# Hay que tirar este comando antes para correr el whenever en development
# crontab -r
# whenever --set environment=development --write-crontab
# Este para volver a production
# crontab -r
# whenever --set environment=production --write-crontab
# 
# Use this file to easily define all of your cron jobs.
#
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
every 1.minutes do
  runner "AlertJob.perform", :environment => 'development'
end
every 1.minutes do
  runner "AlertJob.perform", :environment => 'production'
end
# Learn more: http://github.com/javan/whenever
