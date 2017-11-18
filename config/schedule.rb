require File.expand_path(File.dirname(__FILE__) + "/environment")

set :output, 'log/crontab.log'
ENV['RAILS_ENV'] ||= 'development'
set :environment, ENV['RAILS_ENV']


every 1.minute do
	rake 'matching:execute'
end