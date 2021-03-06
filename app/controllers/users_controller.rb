require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper

class UsersController < ApplicationController
  before_action :logged_in_user, only: [:profile, :edit, :update, :entry, :cancel, :check]
  before_action :correct_user, only: [:cancel]
  # before_action :admin_user,     only: :destroy
  before_action :hobby_registered, only: [:index, :show, :edit, :update, :entry, :check]

  def index
    # ログイン済みの場合
    if logged_in?
      # Top5のhobbyを取得
      @hobby_pop = UserHobby.group(:hobby_name).order('count_all desc').limit(5).count
      # Timelineに表示するtweetを取得(14/page)
      @tweets = Tweet.page(params[:page]).order('created_at DESC').per(14)
      @tweet = Tweet.new
      # 本日の日付を取得
      @today = Date.today
      # アクセス時時刻を取得する
      @time_now = DateTime.now
      # 11:30以前の場合
      if @time_now.strftime('%H:%M:%S') < "11:30:00"
        # 本日のlunchモデルを取得
        @my_lunch = Lunch.where(user_id: current_user.id).where(lunch_date: Date.today).where.not(category_id: nil).find_by(canceled_at: nil)
      else
        # 明日の日付のlunchモデルを取得
        @my_lunch = Lunch.where(user_id: current_user.id).where(lunch_date: Date.tomorrow).where.not(category_id: nil).find_by(canceled_at: nil)
      end

      ########## テーマランチ ############
      # ランチカード表示用の配列
      @cards = []
      # ランチカード用にDailyLunchを取得
      daily_lunches = DailyLunch.get_card
      daily_lunches.each do |daily_lunch|
        @cards.push({category_id: daily_lunch.id,
          category_name: daily_lunch.name,
          is_others: Lunch.is_others(current_user.id, daily_lunch.id), # 他ユーザーが参加していればtrue
          can_entry: true
        })
      end
      ######################

    # 未ログインの場合
    else
      # ログイン前トップ画面を表示
      render 'sessions/index'
    end
  end

  def profile
    @user = current_user
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
      begin
        @user.profile_img.retrieve_from_cache! params[:cache][:profile_img]
      rescue => e
        p e
      end
      if params[:back]
        render :new
        return
      elsif @user.save
        @user.send_activation_email
        flash[:info] = "アカウントを有効化するために送られてきたメールを確認してください。"
        # 仮登録完了/メール認証ページにリダイレクト
        redirect_to account_activation_path
        return
      else
        render 'new'
        return
      end
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました。"
      # プロフィール画面にリダイレクト
      redirect_to users_profile_path
    # 更新に失敗した場合
    else
      # プロフィール更新画面にリダイレクト
      render 'edit'
    end
  end

  # def destroy
  #   User.find(params[:id]).destroy
  #   flash[:success] = "ユーザーを削除しました"
  #   redirect_to users_url
  # end

  def entry
    # エントリー確認画面でユーザープロフィールを表示するためにインスタンス変数に代入
    @user = current_user
    # アクセス時刻を取得する
    @time_now = DateTime.now
    # 11:30以前の場合
    if @time_now.strftime('%H:%M:%S') < "11:30:00"
      # 今日の日付でユーザーがエントリー状態でない場合
      if Lunch.where(user_id: current_user.id).where(lunch_date: Date.today).where.not(category_id: nil).find_by(canceled_at: nil).nil?
        # viewからカテゴリーIDが取得できている場合
        if category_id = params[:category_id]
          Lunch.create(user_id: current_user.id, category_id: category_id, lunch_date: Date.today, friends_num: params[:friends_num])
          flash[:success] = "エントリーしました。"
        else
          flash[:danger] = "エントリーできませんでした。"
        end
        redirect_to root_url
      else
        flash[:info] = "既にエントリー済みです。"
        redirect_to root_url
      end
    else
      # 明日の日付でユーザーがエントリーしていない場合
      if Lunch.where(user_id: current_user.id).where(lunch_date: Date.tomorrow).where.not(category_id: nil).find_by(canceled_at: nil).nil?
        # viewからカテゴリーIDが取得できている場合
        if category_id = params[:category_id]
          Lunch.create(user_id: current_user.id, category_id: category_id, lunch_date: Date.tomorrow, friends_num: params[:friends_num])
          flash[:success] = "エントリーしました。"
        else
          flash[:danger] = "エントリーできませんでした。"
        end
        redirect_to root_url
      else
        flash[:info] = "既にエントリー済みです。"
        redirect_to root_url
      end
    end
  end

  def cancel
    # アクセス時時刻を取得する
    @time_now = DateTime.now
    # 11:30以前の場合
    if @time_now.strftime('%H:%M:%S') < "11:30:00"
      # マッチング済みの場合
      if matched?
        flash[:info] = "既にマッチング済みのためキャンセルできません。"
        redirect_to(root_url)
      else
        # 本日のランチモデルを取得
        lunch = Lunch.where(user_id: current_user.id).where(lunch_date: Date.today).
          where.not(category_id: nil).where(canceled_at: nil).find_by(pair_id: nil)
        # 本日付のランチモデルが存在する場合
        if lunch.present?
          if lunch.update_attribute(:canceled_at, DateTime.now)
            flash[:success] = "キャンセルいたしました。"
            redirect_to(root_url)
          end
        else
          flash[:info] = "未エントリーのためキャンセルできません。"
          redirect_to(root_url)
        end
      end
    else
      # 明日付のランチモデルを取得
      lunch = Lunch.where(user_id: current_user.id).where(lunch_date: Date.tomorrow).
        where.not(category_id: nil).where(canceled_at: nil).find_by(pair_id: nil)
      # ランチモデルが存在する場合
      if lunch.present?
        if lunch.update_attribute(:canceled_at, DateTime.now)
          flash[:success] = "キャンセルいたしました。"
          redirect_to(root_url)
        end
      else
        flash[:info] = "未エントリーのためキャンセルできません。"
        redirect_to(root_url)
      end
    end
  end

  def check
    # マッチング済みのLunchモデルを取得
    @matched_lunch = Lunch.where(user_id: current_user.id).where(lunch_date: Date.today).where.not(category_id: nil).where.not(pair_id: nil).first
    # @lunchが存在している場合
    if @matched_lunch.present?
      # 曜日表示用の配列を定義
      wd = ["日", "月", "火", "水", "木", "金", "土"]
      # 画面表示で使う日付を取得
      @matching_date = Date.today.month.to_s + '/' + Date.today.day.to_s + '(' + wd[Date.today.wday]+ ')'
      @pair_id = @matched_lunch.pair_id
      # 本日付のマッチング相手のuser_idの配列を取得
      # カラム：where.not(sent_at: nil):マッチング結果メールが送信済み
      user_ids = Lunch.where(pair_id: @pair_id).where(lunch_date: Date.today).where.not(sent_at: nil).where.not(user_id: current_user.id).pluck(:user_id)
      # マッチング相手のUserモデルの配列を取得
      @pairs = User.where(id: user_ids)
      # テーマランチ名を取得
      @lunch_theme = DailyLunch.find(@matched_lunch.category_id).name
      # formで必要なインスタンス変数を定義
      @chat = Chat.new
      # 本日のマッチングメンバーのチャットを取得
      @chats = Chat.where(pair_id: @pair_id).where(lunch_date: Date.today).page(params[:page]).order('created_at DESC')

      # マッチングメンバーの投稿の場合
      if params[:pair_id].present? && params[:pair_id].to_i == @pair_id
        @new_chat = []
        chats = Chat.where('id > ?', params[:id]).where(lunch_date: Date.today).where(pair_id: @pair_id)
        chats.each do |chat|
          # 時刻の表示を整形
          # モデルの作成から1日以上経過している場合
          if Time.now - chat.created_at >= 86400
            post_at = chat.created_at.strftime("%Y年 %m月 %d日")
          else
            post_at = time_ago_in_words(chat.created_at) + "前"
          end
          @new_chat.push({ chat: chat, # Chatモデル
                          img_url: chat.user.profile_img.url, # 投稿者のimg_URL
                          user_name: chat.user.name, # 投稿者名
                          post_at: post_at # 投稿時刻(表示用に整形済)
                        })
        end
        respond_to do |format| 
          format.html # html形式でアクセスがあった場合は特に何もなし
          format.json { @new_chat }
        end
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation,
        :profile_img, :profile_img_cache, :department_name, :slack_id, :category_id, :self_intro, :profile_img_data_uri)
    end

    def correct_user
      begin
        @user = User.find(params[:id])
      rescue => e
        p e
      end
      redirect_to(root_url) unless current_user?(@user)
    end

    # # 管理者かどうか確認
    # def admin_user
    #   redirect_to(root_url) unless current_user.present? && current_user.admin?
    # end

    def matched?
      # ログインユーザーがマッチング済みの場合にtrueを返す
      Lunch.where.not(pair_id: nil).where(user_id: current_user.id).where(lunch_date: Date.today).present?
    end

end