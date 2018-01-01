class SessionsController < ApplicationController
  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    if auth.present?
      unless @auth = Authorization.find_from_auth(auth)
        @auth = Authorization.create_from_auth(auth)
      end
      user = @auth.user
      redirect_back_or user
    else
    	user = User.find_by(email:params[:session][:email].downcase)
    	if user && user.authenticate(params[:session][:password])
    		if user.activated?
          log_in user
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    		  redirect_back_or user
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
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end