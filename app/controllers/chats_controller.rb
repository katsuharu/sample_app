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

  def btn_create
    # 取得したものをajaxで一覧表示
    @chats = Chat.where(pair_id: chat_params[:pair_id]).where(lunch_date: Date.today).order('created_at DESC')
    @chat = Chat.new(text: chat_params[:text], user_id: current_user.id, pair_id: chat_params[:pair_id], lunch_date: Date.today)
    respond_to do |format|
      if @chat.save
        format.html
        format.js
      else
        format.js {render :index}
      end
    end
  end

  private

    def chat_params
      params.require(:chat).permit(:text, :user_id, :pair_id)
    end
end