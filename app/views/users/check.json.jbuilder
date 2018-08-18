 # json.array! @messages, partial: 'messages/message', as: :message この記述は消してしまいましょう
if @new_chat.present? # @new_messageに中身があれば
  json.array! @new_chat # 配列かつjson形式で@new_messageを返す
end