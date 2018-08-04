class ChatsController < ApplicationController
  def btn_create
    @chats = Chat.where(pair_id: chat_params[:pair_id]).where(lunch_date: Date.today).order('created_at DESC')
    @chat = Chat.new(text: chat_params[:text], user_id: current_user.id, pair_id: chat_params[:pair_id], lunch_date: Date.today)
    respond_to do |format|
      if @chat.save
        # 投稿者以外の本日付のマッチング相手のuser_idの配列を取得
        # where.not(sent_at: nil):マッチング結果メールが送信済み
        user_ids = Lunch.where(pair_id: chat_params[:pair_id]).where(lunch_date: Date.today) \
        .where.not(sent_at: nil).where.not(user_id: current_user.id).pluck(:user_id)
        # eachで繰り返し処理
        user_ids.each do |id|
          # idからユーザーを取得
          user = User.find(id)
          # ユーザーに投稿通知用のメールを送信
          user.chat_notification_email(User.find(current_user.id), chat_params[:text])
        end

        format.html
        format.js
      else
        format.js {render :index}
      end
    end
  end

  def create
    @chats = Chat.where(pair_id: chat_params[:pair_id]).where(lunch_date: Date.today).order('created_at DESC')
    @chat = Chat.new(text: chat_params[:text], user_id: current_user.id, pair_id: chat_params[:pair_id], lunch_date: Date.today)
    if @chat.save
      # 投稿者以外の本日付のマッチング相手のuser_idの配列を取得
      # where.not(sent_at: nil):マッチング結果メールが送信済み
      user_ids = Lunch.where(pair_id: chat_params[:pair_id]).where(lunch_date: Date.today) \
      .where.not(sent_at: nil).where.not(user_id: current_user.id).pluck(:user_id)
      # eachで繰り返し処理
      user_ids.each do |id|
        # idからユーザーを取得
        user = User.find(id)
        # ユーザーに投稿通知用のメールを送信
        user.chat_notification_email(User.find(current_user.id), chat_params[:text])
      end
    end
  end

  private

    def chat_params
      params.require(:chat).permit(:text, :user_id, :pair_id)
    end
end