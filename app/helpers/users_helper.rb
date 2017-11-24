module UsersHelper
	def entried?
		!current_user.category_id.nil?
	end
end