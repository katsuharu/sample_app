require "bundler/capistrano"

set :application, "lunchfriends"
set :rails_env, "production"


server "https://lunchfriends.jp/", :web, :app, :db, primary: true

set :repository, "https://katsu18@bitbucket.org/lunchfriendsteam/lunchfriends.git"
set :scm, :git
set :branch, "master"
set :user, "vpslunch"
set :use_sudo, false
set :deploy_to, "/var/www/html/lunchfriends"
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true


# レポジトリ設定
set :repo_url, 'https://user_name:pass_word@github.com/user_name/web_app.git'
# シンボリックリンクにするディレクトリ
set :linked_dirs, fetch(:linked_dirs, []).push('log')
# デプロイ先でのソースのバージョンの保持数
set :keep_releases, 5
# コマンド実行時にsudoをつけるか
set :use_sudo, false