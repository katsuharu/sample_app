class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "アカウントの有効化"
  end

  def password_reset(user)
  	@user = user
    mail to: user.email, subject: "パスワードのリセット"
  end

  def matching_success(user)
  	@user = user
    mail to: user.email, subject: "マッチングの完了のお知らせです"
  end
end
