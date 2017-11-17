class MatchingsController < ApplicationController
	before_action :logged_in_user, :correct_user, only: [ :entry]
	before_action :correct_user,   only: [:entry]
	
	@@entry_id = 0
	@@pair_no = 0

	def entry
		@@entry_id += 1
		p @@entry_id
		User.where(id: current_user.id).update(entry_id: @@entry_id)
	  	flash[:success] = "シャッフルランチにエントリーしました。"

		if @@entry_id % 3 == 0
			@@pair_no += 1
			p @@pair_no
			User.where(entry_id: @@entry_id-2 .. @@entry_id).update(pair_id: @@pair_no)

	  		render action: 'show'
	  	end
	end


	private

		def correct_user
		  @user = User.find(params[:id])
		  redirect_to(root_url) unless current_user?(@user)
		end

end