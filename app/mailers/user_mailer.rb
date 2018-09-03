class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "【LunchFriends】リンクをクリックしアカウントを有効化して下さい"
  end

  def password_reset(user)
  	@user = user
    mail to: user.email, subject: "【LunchFriends】パスワードのリセット"
  end

  # def matching_success(user)
  # 	@user = user
  #   mail to: user.email, subject: "【LunchFriends】ランチマッチングが成立しました。"
  # end

  # 引数で受け取るメールの宛先に一斉送信を行うメソッド
  # param Array email_lists メールアドレスの配列
  def matching_success(email_lists)
    if email_lists.present?
      mail(bcc: email_lists, subject: "【LunchFriends】ランチマッチングが成立しました。")
    end
  end

  def matching_fail(user)
    @user = user
    mail to: user.email, subject: "【LunchFriends】本日はランチ相手が見つかりませんでした。"
  end

  def chat_notification(user)
    @user = user
    mail to: user.email, subject: "【LunchFriends/新着メッセージ】マッチング相手からメッセージが届きました！"
  end

  def contact_contents(params)
    @contents = params
    mail to: 'lunchcommunication@gmail.com', subject: "【Lunch Friends】お問い合わせ"
  end
end