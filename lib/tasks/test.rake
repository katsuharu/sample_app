namespace :test do
  task :test => :environment do  | task |
    desc "test task"

    p Time.now.to_s + 'task test start'

    user = User.find_by(email: 'traveler.18.challenge@gmail.com')
    p user
    # ユーザーに投稿通知用のメールを送信
    if UserMailer.chat_notification(user).deliver_now!
      # マッチング成功メールを送信
      UserMailer.matching_success(user)
      # マッチング失敗メールを送信
      UserMailer.matching_fail(user).deliver_now!
      p "Chat notification!!"
    else
      # 投稿通知用のメール送信に失敗
      p "Fail send"
    end

    p Time.now.to_s + 'task test end'
  end
end