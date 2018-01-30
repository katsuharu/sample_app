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

	def edit
		#すでに登録されている趣味項目が削除ボタンを押された場合、アラートで確認後、実際に削除する
		#新規にこの時登録するとき、 user_hobbiesテーブルのレコードに、今登録していようとしている趣味のuser_idとhobby_idが同一のレコードは既に
		#登録されているとみなして登録しない。
		del_num = params[:del_hobbies].count()
		for i in 0..del_num - 1
			UserHobby.where(user_id: current_user.id).where(hobby_name: params[:del_hobbies][i]).destroy_all
		end
	end

	def hobby_show
		@hobbies = UserHobby.where(user_id: current_user.id)
	end
end