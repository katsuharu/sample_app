class SessionsController < ApplicationController
  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    if auth.present?
      auth = env['omniauth.auth']
      p "夏目漱石"
      p auth.info
      p auth.info.name
      p auth
      p auth.info.email
      p "太宰治"
      # @user  = User.from_omniauth(env['omniauth.auth'])
      # if @user.save(context: :facebook_login)
        # log_in user
        # flash[:success] = "ログインしました。" 
        # redirect_back_or user
      # end
    else
    	user = User.find_by(email:params[:session][:email].downcase)
    	if user && user.authenticate(params[:session][:password])
    		if user.activated?
          log_in user
          remember(user)
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