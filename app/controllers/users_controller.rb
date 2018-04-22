class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :entry, :cancel, :check]
  before_action :correct_user, only: [:show, :edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :hobby_registered, only: [:index, :show, :edit, :update, :destroy, :entry, :check, :matching]

  def index
    # Top5のhobbyを取得
    @hobby_pop = UserHobby.group(:hobby_name).order('count_all desc').limit(5).count

    # @tweets = Tweet.all
    @tweets = Tweet.paginate(page: params[:page], per_page: 20).order('created_at DESC')
    @apple = Tweet.new
    @today = Date.today

    # 「Hobby Cards」欄に、4人以上のユーザーが登録した趣味を一覧表示する
    @cards = {"オールジャンル" => 128}        #ログインユーザーが登録している趣味かつ4人以上のユーサーが登録している趣味
    if current_user # current_userがnilのときにエラーになるのを防ぐため
      user_cards = UserHobby.where(user_id: current_user.id).pluck(:hobby_name) #ログインユーザーが登録した趣味名の配列
      # 自分が登録した趣味のなかで、登録ユーザー数が4人以上のhobby_idのhobby_nameを配列インスタンス変数に追加する
      user_cards.each do |u_card|
        if UserHobby.where(hobby_name: u_card).count > 3
          @cards[u_card] = Category.find_by(name: u_card).id
        end
      end
    end

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
    # @user.profile_img.cache!

    render :new if @user.invalid?
  end

  def create
    auth = request.env["omniauth.auth"]
    if auth.present?
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
        UserHobby.create(:hobby_name => 'オールジャンル', :user_id => @user.id)
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

  def update
    @user = User.find(params[:id])
    # 戻るボタンが押された場合
    if params[:back]
      render :edit
    # 写真を選択した状態で「変更を保存」を押した場合
    elsif user_params[:profile_img]
      if @user.update_attributes(user_params)
        flash[:success] = "ユーザー情報を更新しました。"
        render 'show'
      else
        flash[:info] = "プロフィールを更新しませんでした。"
        render 'edit'
      end
    else
    # 写真を選択せず「変更を保存」を押した場合
      #写真以外のカラムを更新
      if User.find(@user.id).update_attributes(name: user_params[:name], email: user_params[:email], password: user_params[:password],password_confirmation: user_params[:password_confirmation] , department_name: user_params[:department_name], slack_id: user_params[:slack_id], self_intro: user_params[:self_intro])
        flash[:success] = "ユーザー情報を更新しました。"
        render 'show'
      else
        flash[:info] = "プロフィールを更新しませんでした。"
        render 'edit'
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url
  end

  def entry
    if current_user.category_id.nil?         #カレントユーザーが未エントリーの場合
      category_id = params[:user][:category_id]
      current_user.update_attribute(:category_id, category_id)
      Lunch.create(user_id: current_user.id, category_id: category_id, lunch_date: Date.today)
      if params[:user][:any_category] == '1'
        current_user.update_attribute(:any_category, 1)
      end
      flash[:success] = "エントリーしました。"
      redirect_to root_url
    end
  end

  def matching
    category_ids = Category.pluck(:id)
    entry_users = Array.new
    ids = Array.new #カテゴリーごとのエントリーユーザーのidを配列として保持
    user_ids = Array.new
    # 全カテゴリーについて、各カテゴリーにエントリーしているエントリーユーザーを取得。
    category_ids.each_with_index do |c_id, i|
      entry_users[i] = User.where(category_id: c_id) #各エントリーカテゴリーごとのユーザーを配列で取得
    end

    entry_users.each_with_index do |e_users, i| #各カテゴリー毎
      e_users.each do |user| #各カテゴリーのエントリーユーザー全てループ
        user_ids.push(user.id) #各カテゴリーにエントリーしている全てのユーザーのidを取得
      end
      ids.push(user_ids)
      entry_num = e_users.count
      remainder = entry_num % 3 #エントリー数を3で割った余り
      quotient = entry_num / 3    #エントリー数を3で割った商

      if entry_num == 0 || entry_num == 1
        #このカテゴリーではペアなし
        e_users.each do |user| 
          user.send_fail_email #マッチング不成立のメールを送信
        end
      elsif entry_num == 2
        User.where("(id = ?) OR (id = ?)",user_ids.shift ,user_ids.shift).update_all(pair_id: 1)
        e_users.each do |user| 
          user.send_success_email #マッチング成立のメールを送信
        end
      elsif entry_num == 5
        User.where("(id = ?) OR (id = ?) OR (id = ?) OR (id = ?) OR (id = ?)",user_ids.shift ,user_ids.shift ,user_ids.shift, user_ids.shift ,user_ids.shift).update_all(pair_id: 1)
        e_users.each do |user| 
          user.send_success_email #マッチング成立のメールを送信
        end
      else
        #3人のペアを quotient数ぶん作る。
        user_ids = user_ids.shuffle #エントリーユーザーのidをシャッフル

        for i in 1..quotient do
          User.where("(id = ?) OR (id = ?) OR (id = ?)",user_ids.shift ,user_ids.shift ,user_ids.shift).update_all(pair_id: i)
        end

        case remainder
        when 0

        when 1
          #そのペアのうちの一つだけ1人足して4人のペアを1つ作る
          User.where("(id = ?)", user_ids.shift).update_attribute(:pair_id, quotient)
        when 2
          #そのペアのうちの2つ1人足して4人のペアを2つ作る
          User.where("(id = ?)", user_ids.shift).update_attribute(:pair_id, quotient-1)
          User.where("(id = ?)", user_ids.shift).update_attribute(:pair_id, quotient)
        end

        e_users.each do |user| 
          user.send_success_email #マッチング成立のメールを送信
        end
      end
    end
  end

  def cancel
    if !current_user.category_id.nil? && current_user.pair_id.nil?
      user_id = current_user.id
      User.find_by(id: user_id).update_attribute(:category_id, nil)
      lunch = Lunch.where(user_id: user_id).where(lunch_date: Date.today).where(is_deleted: nil)
      lunch.update_all(deleted_at: DateTime.now, is_deleted: true)
      flash[:success] = "キャンセルいたしました。"
      redirect_to(root_url)
    end
  end

  def check_entry_cnt
    @user = current_user #エントリー画面(entry.html.erb)でユーザー情報を表示するために変数に代入
    render action: 'check_entry_cnt'
  end
  
  def check
    @pairs = User.where(pair_id: current_user.pair_id).where.not(pair_id: nil).where(category_id: current_user.category_id).where.not(id:current_user.id)
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