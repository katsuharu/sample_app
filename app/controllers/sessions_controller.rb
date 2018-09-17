class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email:params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
  		if user.activated?
        log_in user
        remember(user)
        redirect_to root_url
      else
        message = "アカウントが有効化されておりません。"
        message += "送られてきたメールのリンクでアカウントを有効化してください。"
        flash[:warning] = message
        redirect_to root_url
      end
  	else
  		flash.now[:danger] = 'メールアドレスまたはパスワードが正しくありません。'
    	render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def account_activation
  end
end