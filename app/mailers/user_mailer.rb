class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "【LunchFriends】リンクをクリックしアカウントを有効化して下さい"
  end

  def password_reset(user)
  	@user = user
    mail to: user.email, subject: "【LunchFriends】パスワードのリセット"
  end

  # 引数で受け取るメールの宛先に一斉送信を行うメソッド
  # param Array email_lists メールアドレスの配列
  def matching_success(email_lists)
    if email_lists.present?
      mail(bcc: email_lists, subject: "【LunchFriends】ランチマッチングが成立しました。")
    end
  end

  # 引数で受け取るメールの宛先に一斉送信を行うメソッド
  # param Array email_lists メールアドレスの配列
  def matching_fail(email_lists)
    if email_lists.present?
      mail(bcc: email_lists, subject: "【LunchFriends】本日はランチ相手が見つかりませんでした。")
    end
  end

  # 引数で受け取るメールの宛先に一斉送信を行うメソッド
  # param Array email_lists メールアドレスの配列
  def chat_notification(email_lists)
    if email_lists.present?
      mail(bcc: email_lists, subject: "【LunchFriends/新着メッセージ】マッチング相手からメッセージが届きました！")
    end
  end

  def contact_contents(params)
    @contents = params
    mail to: 'lunchcommunication@gmail.com', subject: "【Lunch Friends】お問い合わせ"
  end
end