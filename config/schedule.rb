## 空だった場合本番として実行
ENV['RAILS_ENV'] ||= 'production'

require File.expand_path(File.dirname(__FILE__) + "/environment")
set :output, 'log/crontab.log'
## 環境ごとに切り合わけ
set :environment, ENV['RAILS_ENV'] 

# 平日の午前09時50分にスケジューリング
every :weekday, at: '09:50 am' do
  rake 'lunch_theme_notification:lunch_theme_notification'
end

# 平日の午前11時30分にスケジューリング
every :weekday, at: '11:30 am' do
  rake 'matching:matching'
end

every 1.minutes do
  rake 'chat_notification_mail:chat_notification_mail'
  # 実験用にお知らせメール送信タスクを追加
  rake 'lunch_theme_notification:lunch_theme_notification'
end

# 平日の10時30にバッチが起動していることをログに出力する
# every :weekday, at: '10:30 am' do
#   rake 'test:test'
# end