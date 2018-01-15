class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :entry, :cancel, :check]
  before_action :correct_user, only: [:show, :edit, :update, :entry, :cancel, :check]
  before_action :admin_user,     only: :destroy

  def index
    if logged_in?
      @user = current_user
      @user.update_attribute(:logined_at, DateTime.now)
      @users = User.where.not(category_id: nil)
    end
  end

  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def confirm
    @user = User.new(user_params) #POSTされたパラメータを取得
    @user.profile_img.cache!

    render :new if @user.invalid?
  end

  def create
    auth = request.env["omniauth.auth"]
    if auth.present?

      p "色川武大"
      p auth.info.image
      p auth.info.user_friends
      p auth.user_friends
      p auth.extra.raw_info.user_friends

      p auth.user_likes
      p auth.info.user_likes
      p auth.extra.raw_info.user_likes
      
      p auth.extra
      p auth.extra.raw_info.user_friends

      p auth.info.first_name
      p auth.info.last_name


      p auth.extra.raw_info.gender
      p auth.extra.raw_info.timezone
      p auth.credentials
      p "太宰治"


      if @auth = Authorization.find_from_auth(auth)
        user = @auth.user
        log_in user
        redirect_back_or user
      else
        @auth = Authorization.create_from_auth(auth)
        user = @auth.user
        log_in user
        remember(user)
        flash[:success] = "ユーザー登録に成功いたしました。"
        redirect_back_or user
      end
    else
    	@user = User.new(user_params)
      @user.profile_img.retrieve_from_cache! params[:cache][:profile_img]
      if params[:back]
        render :new
        return
    	elsif @user.save
        @user.send_activation_email
    		flash[:info] = "アカウントを有効化するために送られてきたメールを確認してください。"
    		redirect_to root_url
        return
    	else
    		render 'new'
        return
    	end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def edit_confirm
    @user = User.new(user_params) #POSTされたパラメータを取得
    @user.profile_img.cache!

    render :new if @user.invalid?
  end

  def update
    @user = User.find(params[:id])
    if params[:back]
      render :edit
    elsif @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      render 'show'
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
    @user = current_user #エントリー画面(entry.html.erb)でユーザー情報を表示するために変数に代入
    if current_user.category_id.nil?         #カレントユーザーが未エントリーの場合
      cate_num = params[:user][:category_id]
      User.find_by(id: current_user.id).update_attribute(:category_id, cate_num)
      cate_cnt = User.where(category_id: cate_num).count
      if params[:user][:any_category] == '1'
        User.find_by(id: current_user.id).update_attribute(:any_category, 1)
      end

      if cate_cnt != 0 && cate_cnt % 3 == 0
        pair_id = cate_cnt / 3
        #まだマッチングしてないcategory_idがcate_numのユーザーのpair_idを更新
        members = User.where(category_id: cate_num).where(pair_id: nil)
        members.update_all(pair_id: pair_id) #pair_idを更新

        #マッチングしたそれぞれの人にマッチングしたことを知らせるためのメールを送信
        members.each do |member|
          member.send_success_email
        end

        redirect_to check_path
        flash[:success] = "マッチングが完了致しました。"
        #エントリーボタンを押してマッチングしたユーザーにマッチング成功のお知らせメールを送信
        return
      end
      
      render action: 'entry'
      return
    else
      redirect_to root_url
      flash[:danger] = "既にエントリー済みです。"
    end
  end

  def cancel
    if !current_user.category_id.nil? && current_user.pair_id.nil?
      User.find_by(id: current_user.id).update_attribute(:category_id, nil)
      
    end
  end

  def check_entry_cnt
    @user = current_user #エントリー画面(entry.html.erb)でユーザー情報を表示するために変数に代入
    render action: 'check_entry_cnt'
  end
  
  def check
    @pairs = User.where(pair_id: current_user.pair_id).where.not(pair_id: nil).where(category_id: current_user.category_id).where.not(id:current_user.id)
  end

  def hobby
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation,
        :profile_img, :profile_img_cache, :department_name, :slack_id, :category_id, :self_intro, :profile_img_data_uri)
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