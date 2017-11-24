module UsersHelper
	def entried?
		!current_user.category_id.nil?
	end

	def matched?
		!current_user.pair_id.nil?
	end
end