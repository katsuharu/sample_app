class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "【LunchFriends】リンクをクリックしアカウントを有効化して下さい"
  end

  def password_reset(user)
  	@user = user
    mail to: user.email, subject: "【LunchFriends】パスワードのリセット"
  end

  def matching_success(user)
  	@user = user
    mail to: user.email, subject: "【LunchFriends】ランチマッチングが成立しました。"
  end

  def matching_fail(user)
    @user = user
    mail to: user.email, subject: "【LunchFriends】本日はランチ相手が見つかりませんでした。"
  end

  def contact_contents(params)
    @contents = params
    mail to: 'lunchcommunication@gmail.com', subject: "【Lunch Friends】お問い合わせ"
  end
end