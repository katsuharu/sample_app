class UserHobbiesController < ApplicationController
	def hobby
	  p "吉田松陰"
	  @hobby = UserHobby.new
	  p @hobby
	end

	def hobby_save
		hobby_num = params[:user_hobby][:hobby_name].count()

		for i in 0..hobby_num - 1
			@hobby = UserHobby.create(:hobby_name => params[:user_hobby][:hobby_name][i], :user_id => current_user.id)
		end
	  	
	  	flash[:success] = "趣味を登録いたしました。"
	end

end