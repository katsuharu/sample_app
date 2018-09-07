class Lunch < ApplicationRecord
  def self.get_entry_user_ids(category_id)
    return Lunch.where(lunch_date: Date.today).where(category_id: category_id).where(canceled_at: nil).pluck(:user_id)
  end

  def self.send_success_email(email_lists)
    # メール一斉位送信
    UserMailer.matching_success(email_lists).deliver_later!
  end

  def self.send_fail_email(email_lists)
    # メール一斉位送信
    UserMailer.matching_fail(email_lists).deliver_later!
  end
end