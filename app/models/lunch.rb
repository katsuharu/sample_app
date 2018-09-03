class Lunch < ApplicationRecord
  def self.get_entry_user_ids(category_id)
    return Lunch.where(lunch_date: Date.today).where(category_id: category_id).where(canceled_at: nil).pluck(:user_id)
  end

  # def self.send_success_email(lunches)
  #   # 参加ユーザーのメアドの配列を取得
  #   email_lists = User.where(id: lunches.pluck(:user_id)).pluck(:email)
  #   # メール一斉位送信
  #   if UserMailer.matching_success(email_lists).deliver_now!
  #     # sent_atカラムを更新
  #     lunches.update_all(sent_at: DateTime.now)
  #   end
  # end

  def self.send_success_email(email_lists)
    # メール一斉位送信
    UserMailer.matching_success(email_lists).deliver_now!
  end
end