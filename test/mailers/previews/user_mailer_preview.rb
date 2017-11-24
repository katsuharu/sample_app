# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

  def matching_success
    user = User.first
    user.activation_token = User.new_token
    UserMailer.matching_success(user)
  end

  def contact_contents
    params = {:name => "佐々木希", :email => "traveler@gamil.com", :content => "アンジャッシュ"}
    UserMailer.contact_contents(params)
  end

end