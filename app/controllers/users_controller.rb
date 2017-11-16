class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  @@entry_id = 0
  @@pair_no = 0

  def index
    @users = User.all
  end

  def show
  	@user = User.find(params[:id])
    # @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      @user.send_activation_email
  		flash[:info] = "アカウントを有効化するために送られてきたメールを確認してください。"
  		redirect_to root_url
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 更新に成功した場合を扱う。
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url
  end

  def entry
    @@entry_id += 1
    p @@entry_id
    User.where(id: current_user.id).update(entry_id: @@entry_id)
      flash[:success] = "シャッフルランチにエントリーしました。"

    if @@entry_id % 3 == 0
      @@pair_no += 1
      p @@pair_no
      User.where(entry_id: @@entry_id-2 .. @@entry_id).update(pair_id: @@pair_no)

        render action: 'show'
      end
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation, :department_name, :slack_id)
  	end

    #ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end