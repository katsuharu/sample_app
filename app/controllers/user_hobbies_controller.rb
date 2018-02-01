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
				puts str
				UserHobby.where(user_id: current_user.id).where(hobby_name: str).destroy_all
			end
		end

		
	end

	def hobby_show
		@hobbies = UserHobby.where(user_id: current_user.id)
	

		# 「Hobby Cards」欄に、4人以上のユーザーが登録した趣味を一覧表示する
		@cards = Array.new

		# 全てのhobby_idをチェックして、登録ユーザー数が4人以上のhobby_idのhobby_nameを配列インスタンス変数に追加する
		for i in 1..3 do 
			if UserHobby.where(hobby_id: i).count > 3		#一旦、hobby_id順にsortしてからやった方がcountしやすい？
				p UserHobby.find_by(hobby_id: i).hobby_name
				@cards.push(UserHobby.find_by(hobby_id: i).hobby_name)
			end
		end

	end
end