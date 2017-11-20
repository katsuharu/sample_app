class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  @@entry_id = 0
  @@pair_id = 0

  def index
    @users = User.paginate(page:params[:page])
  end

  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in @user
      flash[:success] = "ユーザー登録に成功いたしました。"
      redirect_to root_url
      # @user.send_activation_email
  		# flash[:info] = "アカウントを有効化するために送られてきたメールを確認してください。"
  		# redirect_to root_url
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
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to user_path
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
    if current_user.entry_id.nil?         #カレントユーザーが未エントリーの場合
      @@entry_id += 1
      User.find_by(id: current_user.id).update_attribute(:entry_id, @@entry_id)
      flash[:success] = "シャッフルランチにエントリーしました。"

      if @@entry_id % 3 == 0
        @@pair_id += 1
        p @@pair_id
        User.find_by(entry_id: @@entry_id-2).update_attribute(:pair_id,  @@pair_id)
        User.find_by(entry_id: @@entry_id-1).update_attribute(:pair_id,  @@pair_id)
        User.find_by(entry_id: @@entry_id).update_attribute(:pair_id,  @@pair_id)
        render action: 'success'
      
      else
        redirect_to root_url
        flash[:success] = "マッチング相手が決まり次第メールでおしらせいたします。"
      end
    else
      redirect_to root_url
      flash[:danger] = "既にエントリー済みです。"
    end
  end
  
  def check
    @pairs = User.where(pair_id: current_user.pair_id)
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation,
        :profile_img, :department_name, :slack_id)
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