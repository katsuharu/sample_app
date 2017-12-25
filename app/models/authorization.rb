class Authorization < ApplicationRecord
	belongs_to :user
	#:providerと:uidはもちろんのことユーザーとの紐付け(:user_id)も保証
	validates_presence_of :user_id, :uid, :provider
	#:providerと:uidのペアは一意であることを保証
	validates_uniqueness_of :uid, uniqueness: {:scope => :provider}
end