class TweetsController < ApplicationController
	def create
		@tweets = Tweet.all
		respond_to do |format|
			if Tweet.create(content: tweet_params[:content], user_id: current_user.id)
				p "Git tatekawa"
				format.html
				format.js
			else
				p "Oos"
				# format.js {render :new}
			end
		end
	end


	def show
		@tthread = TThread.new
		@tthreads = TThread.where(tweet_id: params[:id])
	end

	def thread_create
		@tthread = TThread.new
		respond_to do |format|
			if TThread.create(tweet_id: params[:t_thread][:tweet_id], content: tthread_params[:content])
				@tthreads = TThread.where(tweet_id: params[:t_thread][:tweet_id])
				format.html
				format.js
			else
				format.js {render :index}
			end
		end
	end


	private
 
		def tweet_params
      		params.require(:tweet).permit(:content)
    	end

		def tthread_params
      		params.require(:t_thread).permit(:content, :tweet_id)
    	end
end