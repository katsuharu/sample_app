namespace :chat_notification_mail do
  task :chat_notification_mail => :environment do  | task |
    desc "send chat notification mail"
    p Time.now.to_s + 'chat_notification_mail start'
    
    # chatsテーブルから投稿通知メール未返信のレコードを取得
    chats = Chat.where(sent_at: nil).where(lunch_date: Date.today).limit(200)
    p chats
    # 取得件数が0の場合は処理を終了する
    if chats.count == 0
      p Time.now.to_s + 'chat_notification_mail count 0 end'
      exit
    end

    # user_idとpair_idの配列を要素とする配列を重複なく取得する
    chat_user_datas = chats.pluck(:user_id, :pair_id).uniq
    p chat_user_datas
    # ユーザーID用の配列を定義
    member_ids = []
    chat_user_datas.each do |data|
      # 投稿者以外のマッチングメンバーのユーザーIDの配列を取得
      ids = Lunch.where(pair_id: data[1]).where(lunch_date: Date.today) \
      .where.not(user_id: data[0]).pluck(:user_id)

      p ids
      # 投稿者以外のマッチングメンバーのuser_idをmember_ids配列に追加する
      ids.each do |id|
        member_ids.push(id)
      end
    end

    p member_ids
    # マッチングメンバーのユーザーIDからメールアドレスの配列を重複なしで取得
    email_lists = User.where(id: member_ids).pluck(:email).uniq
    p email_lists
    # メアドの配列を使ってユーザーに投稿通知メールを一斉送信
    if User.chat_notification_email(email_lists)
      # レコードのsent_atカラムを現在時刻の値で更新
      chats.update_all(sent_at: DateTime.now)
    end
    p Time.now.to_s + 'chat_notification_mail end'
  end

end