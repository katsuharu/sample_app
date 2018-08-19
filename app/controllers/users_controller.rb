require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper

class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :entry, :cancel, :check]
  # before_action :correct_user, only: [:show, :edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :hobby_registered, only: [:index, :show, :edit, :update, :destroy, :entry, :check]

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
      # ログインユーザーがエントリー中のlunchモデルを取得
      @my_lunch = Lunch.where(user_id: current_user.id).where(lunch_date: Date.today).where.not(category_id: nil).find_by(canceled_at: nil)
      # ランチカードの配列。初期値としてオールジャンルカテゴリーを代入
      @cards = [{category_id: 128,
                category_name: 'オールジャンル',
                users: User.where(id: Lunch.get_entry_user_ids(128)) # オールジャンルにエントリー中のUserモデルの配列
                }]
      # 投稿フォームのカテゴリーセレクト用のハッシュを定義
      @tw_selects = {"オールジャンル" => 128}
      # ログインユーザーが登録したカテゴリーの名前の配列を取得
      user_cards = UserHobby.where(user_id: current_user.id).pluck(:hobby_name)
      user_cards.each do |u_card|
        # 自分が登録したカテゴリーのなかで登録ユーザー数が3人以上のhobby_idのhobby_nameを配列インスタンス変数に追加する
        if UserHobby.where(hobby_name: u_card).count > 2
          category_id = Category.find_by(name: u_card).id
          # このカテゴリーにエントリー中の場合
          if @my_lunch.present? && category_id == @my_lunch.category_id
            # ランチカードで一番最初に表示されるように配列の先頭にハッシュを追加
            @cards.unshift(
            {category_id: category_id, # カテゴリーID
            category_name: u_card, # 3名以上のユーザーが登録したカテゴリーのカテゴリ名
            users: User.where(id: Lunch.get_entry_user_ids(category_id)) # 各カテゴリーにエントリー中のUserモデルの配列
            })
          else
            # 配列の末尾にハッシュを追加
            @cards.push(
            {category_id: category_id, # カテゴリーID
            category_name: u_card, # 3名以上のユーザーが登録したカテゴリーのカテゴリ名
            users: User.where(id: Lunch.get_entry_user_ids(category_id)) # 各カテゴリーにエントリー中のUserモデルの配列
            })
          end
          # カテゴリーハッシュに追加
          @tw_selects[u_card] = category_id
        end
      end

      @user = current_user
      # @user.update_attribute(:logined_at, DateTime.now)
      @users = User.where.not(category_id: nil)


      # Timelineに投稿された場合
      if params[:id].present?
        @new_tweets = []
        tweets = Tweet.where('id > ?', params[:id])
        tweets.each do |tweet|
          # 時刻の表示を整形
          # モデルの作成から1日以上経過している場合
          if Time.now - tweet.created_at >= 86400
            post_at = posted_at.strftime("%Y年 %m月 %d日")
          else
            post_at = time_ago_in_words(tweet.created_at) + "前"
          end

          # カテゴリー名を取得
          category_name = Category.find_by(id: tweet.category_id).name if tweet.category_id.present?
          # 返信数を取得
          thread_count = TThread.where(tweet_id: tweet.id).count

          @new_tweets.push({ tweet: tweet, # Tweetモデル
                          img_url: tweet.user.profile_img.url, # 投稿者のimg_URL
                          user_name: tweet.user.name, # 投稿者名
                          post_at: post_at, # 投稿時刻(表示用に整形済)
                          category_name: category_name, # カテゴリー名
                          thread_count: thread_count, # 返信数
                        })
        end
        respond_to do |format| 
          format.html # html形式でアクセスがあった場合は特に何もなし
          format.json { @new_tweets }
        end
      end

    # 未ログインの場合
    else
      # ログイン前トップ画面を表示
      render 'sessions/index'
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
      redirect_to edit_use_path
    # 写真を選択した状態で「変更を保存」を押した場合
    elsif user_params[:profile_img]
      if @user.update_attributes(user_params)
        flash[:success] = "ユーザー情報を更新しました。"
        redirect_to user_path
      else
        flash[:info] = "プロフィールを更新しませんでした。"
        redirect_to edit_user_path
      end
    # 写真を選択せず「変更を保存」を押した場合
    else
      #写真以外のカラムを更新
      if User.find(@user.id).update_attributes(name: user_params[:name], email: user_params[:email], password: user_params[:password],password_confirmation: user_params[:password_confirmation] , department_name: user_params[:department_name], slack_id: user_params[:slack_id], self_intro: user_params[:self_intro])
        flash[:success] = "ユーザー情報を更新しました。"
        redirect_to user_path 
      else
        flash[:info] = "プロフィールを更新しませんでした。"
        redirect_to edit_user_path
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url
  end

  def entry
    #エントリー確認画面でユーザープロフィールを表示するためにインスタンス変数に代入
    @user = current_user
    # 今日の日付でユーザーがエントリー状態でない場合
    if Lunch.where(user_id: current_user.id).where(lunch_date: Date.today).where.not(category_id: nil).find_by(canceled_at: nil).nil?
      # viewからカテゴリーIDが取得できている場合
      if category_id = params[:category_id]
        Lunch.create(user_id: current_user.id, category_id: category_id, lunch_date: Date.today)
        flash[:success] = "エントリーしました。"
      else
        flash[:danger] = "エントリーできませんでした。"
      end
      redirect_to root_url
    end
  end

  def cancel
    # エントリー中で未マッチングのユーザーが存在する場合
    lunch = Lunch.where(user_id: current_user.id).where(lunch_date: Date.today).
      where.not(category_id: nil).where(canceled_at: nil).find_by(pair_id: nil)
    if !lunch.nil?
      if lunch.update_attribute(:canceled_at, DateTime.now)
        flash[:success] = "キャンセルいたしました。"
        redirect_to(root_url)
      else
      end
    else
    end
  end

  def check_entry_cnt
    #エントリー画面(entry.html.erb)でユーザー情報を表示するために変数に代入
    @user = current_user
    redirect_to check_entry_cnt_path
  end
  
  def check
    # マッチング済みのLunchモデルを取得
    @matched_lunch = Lunch.where(user_id: current_user.id).where(lunch_date: Date.today).where.not(category_id: nil).where.not(pair_id: nil).first
    # @lunchが存在している場合
    if @matched_lunch.present?
      @pair_id = @matched_lunch.pair_id
      # 本日付のマッチング相手のuser_idの配列を取得
      # カラム：where.not(sent_at: nil):マッチング結果メールが送信済み
      user_ids = Lunch.where(pair_id: @pair_id).where(lunch_date: Date.today).where.not(sent_at: nil).where.not(user_id: current_user.id).pluck(:user_id)
      # マッチング相手のUserモデルの配列を取得
      @pairs = User.where(id: user_ids)

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
            post_at = posted_at.strftime("%Y年 %m月 %d日")
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
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end