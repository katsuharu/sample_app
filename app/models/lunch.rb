class Lunch < ApplicationRecord
  def self.get_entry_user_ids(category_id)
    return Lunch.where(lunch_date: Date.today).where(category_id: category_id).where(canceled_at: nil).pluck(:user_id)
  end
end