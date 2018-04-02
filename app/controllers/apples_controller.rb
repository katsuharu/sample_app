class ApplesController < ApplicationController
	def create
		@apples = Tweet.all.order('created_at DESC')
		@apple = Tweet.new(apple_params)
		respond_to do |format|
			if Tweet.create(content: apple_params[:content], user_id: current_user.id, category_id: apple_params[:category_id])
				format.html
				format.js
			else
				format.js {render :index}
			end
		end

	end

	private
		def apple_params
			params.require(:tweet).permit(:content, :category_id)
		end

end