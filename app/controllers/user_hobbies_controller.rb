class UserHobbiesController < ApplicationController
	def hobby
	  @hobby = UserHobby.new
	  @first_categories = FirstCategory.pluck(:id, :name)
	  @second_categories = SecondCategory.pluck(:id, :name, :first_category_id)
	  @third_categories = ThirdCategory.pluck(:id, :name, :second_category_id)
	  @forth_categories = ForthCategory.pluck(:id, :name, :third_category_id)
	end

	def hobby_save
		hobby_num = params[:user_hobby][:hobby_name].count()

		for i in 0..hobby_num - 1
			if params[:user_hobby][:hobby_name][i].empty?
			else
				@hobby = UserHobby.create(:hobby_name => params[:user_hobby][:hobby_name][i], :user_id => current_user.id)
			end
		end
	  	User.find_by(id: current_user.id).update_attribute(:hobby_added, 1)
	  	flash[:success] = "趣味を登録いたしました。"
	  	redirect_to root_url
	end

	def edit
		#すでに登録されている趣味項目が削除ボタンを押された場合、アラートで確認後、実際に削除する
		#新規にこの時登録するとき、 user_hobbiesテーブルのレコードに、今登録していようとしている趣味のuser_idとhobby_idが
		#同一のレコードは既に登録されているとみなして登録しない。

		# add hobby リストにユーザーが追加した趣味を正式にユーザーの趣味として登録する
		if add_hobbies = params[:user_hobby][:hobby_name]
			i = 0
			for str in add_hobbies
				puts i
				puts str

				unless UserHobby.where(user_id: current_user.id).where(hobby_name: str).exists? then
					if str.empty?
						puts "this value is empty"
					else
						p "not exit this record"
						UserHobby.create(hobby_name: str, user_id: current_user.id)
					end
				end

				i += 1
			end

			redirect_to hobby_show_path
			flash[:success] = "趣味を更新しました"
		end


		# ユーザーが削除するためにチェックした趣味をテーブルから削除
		del_hobbies = params[:del_hobbies]
		if del_hobbies
		
			for str in del_hobbies
				UserHobby.where(user_id: current_user.id).where(hobby_name: str).destroy_all
			end
		end

		
	end

	def hobby_show
		@first_categories = FirstCategory.pluck(:id, :name)
		@second_categories = SecondCategory.pluck(:id, :name, :first_category_id)
		@third_categories = ThirdCategory.pluck(:id, :name, :second_category_id)
		@forth_categories = ForthCategory.pluck(:id, :name, :third_category_id)
		@hobbies = UserHobby.where(user_id: current_user.id).where.not(hobby_name: 'オールジャンル')
	end

	def del_hobby
		params[:user_hobbies][:id].each do |id| 
			UserHobby.find(id).destroy()
		end
		flash[:success] = "趣味を削除いたしました。"
		redirect_to hobby_show_path
	end
end