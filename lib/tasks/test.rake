namespace :test do
  task :test => :environment do  | task |
    desc "メール送信処理の処理時間を確認するタスク"

    p Time.now.to_s + 'Mailtask test start'

    # 150件のメールアドレスを取得
    User.all.limit(150).pluck(:email).slice(0..149)

    # 一度に150件送れるかテスト
    if User.chat_notification_email(email_lists)
      p "OK!!!"
    else
      p "cannnot send"
    end

    p Time.now.to_s + 'task test end'
  end
end