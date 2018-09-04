class ChatsController < ApplicationController
  def create
    # @chats = Chat.where(pair_id: chat_params[:pair_id]).where(lunch_date: Date.today).order('created_at DESC')
    @chat = Chat.new(text: chat_params[:text], user_id: current_user.id, pair_id: chat_params[:pair_id], lunch_date: Date.today)
    @chat.save

    # 時刻の表示を整形
    # モデルの作成から1日以上経過している場合
    if Time.now - @chat.created_at >= 86400
      post_at = @chat.created_at.strftime("%Y年 %m月 %d日")
    else
      post_at = time_ago_in_words(@chat.created_at) + "前"
    end

    # view表示用にインスタンス変数を再定義
    @chat = 
      { chat: @chat, # Chatモデル
        img_url: @chat.user.profile_img.url, # 投稿者のimg_URL
        user_name: @chat.user.name, # 投稿者名
        post_at: post_at # 投稿時刻(表示用に整形済)
      }
  end

  # param String pair_id ペアID(ajaxで送信)
  # param String user_id 投稿者のユーザーID(ajaxで送信)
  def send_mail
    # 投稿者以外のマッチング相手のuser_idを配列で取得
    user_ids = Lunch.where(pair_id: params[:pair_id]).where(lunch_date: Date.today) \
    .where.not(sent_at: nil).where.not(user_id: params[:user_id]).pluck(:user_id) # where.not(sent_at: nil):マッチング結果メールが送信済み

    # ユーザーのメアドの配列を取得
    email_lists = User.where(id: user_ids).pluck(:email)
    # メンバーに投稿通知用のメールを送信
    User.chat_notification_email(email_lists)

    # # マッチングメンバーの数だけ繰り返し処理を実行
    # user_ids.each do |id|
    #   # idからユーザーを取得
    #   user = User.find(id)
    #   # ユーザーに投稿通知用のメールを送信
    #   user.chat_notification_email
    # end
  end

  private

    def chat_params
      params.require(:chat).permit(:text, :user_id, :pair_id)
    end
end