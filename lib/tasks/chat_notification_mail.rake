namespace :chat_notification_mail do
  task :chat_notification_mail => :environment do  | task |
    desc "send chat notification mail"
    p Time.now.to_s + 'chat_notification_mail start'
    
    # chatsテーブルから投稿通知メール未返信のレコードを最大で100件取得
    chats = Chat.where(sent_at: nil).where(lunch_date: Date.today).limit(100)
    # 取得件数が0の場合は処理を終了する
    if chats.count == 0
      p Time.now.to_s + 'chat_notification_mail count 0 end'
      exit
    end

    # user_idとpair_idの配列を要素とする配列を重複なく取得する
    chat_user_datas = chats.pluck(:user_id, :pair_id).uniq
    # メール送信宛先のユーザーIDの配列を定義
    send_user_ids = []
    chat_user_datas.each do |data|
      # 各マッチングペアの投稿者以外のユーザーIDの配列を取得
      pair_recieve_message_user_ids = getPairRecieveMessageUserIds(data[0], data[1])
      # 投稿者以外のマッチングメンバーのuser_idをsend_user_ids配列に追加
      pair_recieve_message_user_ids.each do |id|
        send_user_ids.push(id)
      end
    end

    # マッチングメンバーのユーザーIDからメールアドレスの配列を重複なしで取得
    email_lists = User.where(id: send_user_ids).pluck(:email).uniq
    p "email counts #{email_lists.count}"

    while email_lists.present?
      # 100件の宛先に一斉送信
      p User.chat_notification_email(email_lists.slice!(0..99))
      p "Show minus email lists #{email_lists.count}"
    end
    # レコードのsent_atカラムを現在時刻の値で更新
    chats.update_all(sent_at: DateTime.now)

    p Time.now.to_s + 'chat_notification_mail end'
  end

  private

    # 投稿者以外のマッチングメンバーのユーザーIDの配列を取得する関数
    # param Integer user_id ユーザーID
    # param Integer pair_id ペアID
    def getPairRecieveMessageUserIds(user_id, pair_id)
      Lunch.where(pair_id: pair_id).where(lunch_date: Date.today) \
      .where.not(user_id: user_id).pluck(:user_id)
    end

end