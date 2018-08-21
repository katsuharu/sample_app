# config valid only for current version of Capistrano
# lock '3.3.5'

set :application, 'lunchfriends'
# set :repo_url, 'https://katsu18@bitbucket.org/lunchfriendsteam/lunchfriends.git'
set :repo_url, 'git@github.com:katsuharu/sample_app.git'
# set :repo_url, 'git@bitbucket.org:lunchfriendsteam/lunchfriends.git'
# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/lunchfriends'
set :user, "vpslunch"
# Default value for :scm is :git

# set :scm, :git
set :rvm_ruby_version, '2.4.4'
# set rbenv
# set :rbenv_type, :user # or :system, depends on your rbenv setup
# set :rbenv_ruby, '2.4.3'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# set whenever command
# set :whenever_command, "bundle exec whenever --update-crontab"
# set :whenever_command, "bundle exec whenever"
# require "whenever/capistrano"

namespace :deploy do

  desc 'rails db migrate reset & db seed'
  task :migrate_reset do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:migrate:reset DISABLE_DATABASE_ENVIRONMENT_CHECK=1'
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end

end