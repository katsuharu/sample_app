require File.expand_path(File.dirname(__FILE__) + "/environment")


set :output, 'log/crontab.log'
ENV['RAILS_ENV'] ||= 'development'
set :environment, ENV['RAILS_ENV']


# 1分毎に回す
every 1.minute do
  command "echo 'mossmossmossmossmossmoss'"
end

every 1.minute do
	rake 'matching:sample'
end