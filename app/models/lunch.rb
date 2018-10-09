class Lunch < ApplicationRecord
  def self.get_entry_user_ids(category_id)
    # 11:30以前の場合
    if DateTime.now.strftime('%H:%M:%S') < "11:30:00"
      # 今日の日付で引数のカテゴリーidを持つランチモデルを取得してそれらのuser_idを取得
      Lunch.where(lunch_date: Date.today).where(category_id: category_id).where(canceled_at: nil).pluck(:user_id).uniq
    else
      # 明日の日付で引数のカテゴリーidを持つランチモデルを取得してそれらのuser_idを取得
      Lunch.where(lunch_date: Date.tomorrow).where(category_id: category_id).where(canceled_at: nil).pluck(:user_id).uniq
    end
  end

  # 引数のユーザー以外のユーザーが対象のカテゴリーにエントリー済みの場合にtrueを返す関数
  def self.is_others(current_user_id, category_id)
    # 11:30以前の場合
    if DateTime.now.strftime('%H:%M:%S') < "11:30:00"
      # 今日の日付の自分以外のユーザーがエントリーしている対象のカテゴリーのLunchモデルが存在する場合にtrue、そうでない場合にfalseを返す
      Lunch.where(lunch_date: Date.today).where(category_id: category_id).where(canceled_at: nil).where.not(user_id: current_user_id).present?
    else
      # 明日の日付の自分以外のユーザーがエントリーしている対象のカテゴリーのLunchモデルが存在する場合にtrue、そうでない場合にfalseを返す
      Lunch.where(lunch_date: Date.tomorrow).where(category_id: category_id).where(canceled_at: nil).where.not(user_id: current_user_id).present?
    end
  end

  def self.send_success_email(email_lists)
    # メール一斉位送信
    UserMailer.matching_success(email_lists).deliver_now!
  end

  def self.send_fail_email(email_lists)
    # メール一斉位送信
    UserMailer.matching_fail(email_lists).deliver_now!
  end
end