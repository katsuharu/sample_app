class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    # ユーザーが存在しかつ非有効の状態かつの場合
    if user.present? && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "アカウントが有効化されました。"
      redirect_to root_url
    # 既に有効化されている場合
    elsif user.activated? && user.authenticated?(:activation, params[:id])
      flash[:info] = "アカウントは既に認証済みです。"
      redirect_to root_url
    else
      flash[:danger] = "このリンクは無効です。"
      redirect_to root_url
    end
  end
end