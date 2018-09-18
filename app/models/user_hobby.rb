class UserHobby < ApplicationRecord
  validates :user_id, presence: true
  validates :hobby_id, presence: true
  validates :hobby_name, presence: true, length: { maximum:20 }
end