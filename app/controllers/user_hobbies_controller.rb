class UserHobbiesController < ApplicationController
	def hobby
	  p "吉田松陰"
	  @hobby = UserHobby.new
	  p @hobby
	end

	def hobby_save
	  # UserHobby.create(:hobby_name => "カラス")
	  redirect_to root_url
	  flash[:success] = "趣味を登録いたしました。"
	end
end