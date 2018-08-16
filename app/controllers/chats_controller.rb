class ChatsController < ApplicationController
  def btn_create
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

  def create
    @chats = Chat.where(pair_id: chat_params[:pair_id]).where(lunch_date: Date.today).order('created_at DESC')
    @chat = Chat.new(text: chat_params[:text], user_id: current_user.id, pair_id: chat_params[:pair_id], lunch_date: Date.today)
    @chat.save
  end

  private

    def chat_params
      params.require(:chat).permit(:text, :user_id, :pair_id)
    end
end