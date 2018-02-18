class TweetsController < ApplicationController
	def create

		if Tweet.create(content: tweet_params[:content], user_id: current_user.id)
			p "Git tatekawa"
			# format.html
			# format.js
		else
			p "Oos"
			# format.js {render :new}
		end
	end


	private

		def tweet_params
      		params.require(:tweet).permit(:content)
    	end
end