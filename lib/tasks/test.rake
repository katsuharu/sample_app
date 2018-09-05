namespace :test do
  task :test => :environment do  | task |
    desc "メール送信処理の処理時間を確認するタスク"

    p Time.now.to_s + 'Mailtask test start'
    # メールアドレスの配列を定義
    email_lists =  ["user_01@gmail.com", "user_02@gmail.com"]
    # 333回メール送信処理を実行
    for i in 1..333
      User.chat_notification_email(email_lists)
    end

    p Time.now.to_s + 'task test end'
  end
end