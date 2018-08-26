namespace :test do
  task :test => :environment do  | task |
    desc "test task"

    p Time.now.to_s + 'task test start'
    p Time.now.to_s + 'task test end'

    user = User.first
    # ユーザーに投稿通知用のメールを送信
    if user.chat_notification_email
      p "Chat notification!!"
    else
      p "Fail send"
    end
  end
end