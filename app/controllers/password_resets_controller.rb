class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] 
  
  def new
  end

  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード再リセット用のメールが送信されました。"
      redirect_to root_url
    else
      flash.now[:danger] = "メールアドレスが見つかりませんでした。"
      render 'new'
    end
  end

  def edit
  end
end
