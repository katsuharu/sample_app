class TweetsController < ApplicationController

	def btn_create
		@tweets = Tweet.all.order('created_at DESC')
		@tweet = Tweet.new(tweet_params)
		respond_to do |format|
			if Tweet.create(content: tweet_params[:content], user_id: current_user.id, category_id: tweet_params[:category_id])
				format.html
				format.js
			else
				format.js {render :index}
			end
		end

	end

	def create
		@tweets = Tweet.all.order('created_at DESC')
		@tweet = Tweet.new(tweet_params)
		if Tweet.create(content: tweet_params[:content], user_id: current_user.id, category_id: tweet_params[:category_id])
		else
		end
	end



	def show
		@tthread = TThread.new
		@tthreads = TThread.where(tweet_id: params[:id])
	end

	def thread_create
		@tthread = TThread.new
		respond_to do |format|
			if TThread.create(tweet_id: params[:t_thread][:tweet_id], content: tthread_params[:content], user_id: current_user.id)
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
      		params.require(:tweet).permit(:content, :category_id)
    	end

		def tthread_params
      		params.require(:t_thread).permit(:content, :tweet_id)
    	end
end