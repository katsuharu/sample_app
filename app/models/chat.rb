class Chat < ApplicationRecord
  belongs_to :user

  after_create do
    # 投稿者以外の本日付のマッチング相手のuser_idの配列を取得
    # where.not(sent_at: nil):マッチング結果メールが送信済み
    user_ids = Lunch.where(pair_id: self.pair_id).where(lunch_date: Date.today) \
    .where.not(sent_at: nil).where.not(user_id: self.user_id).pluck(:user_id)
    # マッチングメンバーの数だけ繰り返し処理を実行
    user_ids.each do |id|
      # idからユーザーを取得
      user = User.find(id)
      # ユーザーに投稿通知用のメールを送信
      user.chat_notification_email
    end
  end

end