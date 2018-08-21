## 空だった場合本番として実行
ENV['RAILS_ENV'] ||= 'production'

require File.expand_path(File.dirname(__FILE__) + "/environment")
set :output, 'log/crontab.log'
## 環境ごとに切り合わけ
set :environment, ENV['RAILS_ENV'] 

# 平日の12時30分にスケジューリング
every :weekday, at: '12:30 pm' do
    rake 'matching:matching'
end

# 平日の11時30にバッチが起動していることをログに出力する
every :weekday, at: '11:30 am' do
    command "echo 'Batch exactly works well!!'"
end


every 1.minute do
  rake 'test:test'
end
