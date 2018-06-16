class TweetsController < ApplicationController

	def btn_create
		@tweets = Tweet.all.order('created_at DESC')
		@tweet = Tweet.new(content: tweet_params[:content], user_id: current_user.id, category_id: tweet_params[:category_id])
		respond_to do |format|
			if @tweet.save
				format.html
				format.js
			else
				format.js {render :index}
			end
		end

	end

	def create
		@tweets = Tweet.all.order('created_at DESC')
		@tweet = Tweet.new(content: tweet_params[:content], user_id: current_user.id, category_id: tweet_params[:category_id])
		if @tweet.save
		else
		end
	end



	def show
		@tthread = TThread.new
		@tthreads = TThread.where(tweet_id: params[:id])
	end

	def thread_create
		@tthread = TThread.new(tweet_id: params[:t_thread][:tweet_id], content: tthread_params[:content], user_id: current_user.id)
		respond_to do |format|
			if @tthread.save
				@tthreads = TThread.where(tweet_id: params[:t_thread][:tweet_id])
				@thread_counts = @tthreads.count
				@tweet_id = params[:t_thread][:tweet_id]
				format.html
				format.js
			else
				format.js {render :index}
			end
		end
	end

	private

		def tweet_params
      		params.require(:tweet).permit(:content, :user_id, :category_id)
    	end

		def tthread_params
      		params.require(:t_thread).permit(:content, :tweet_id)
    	end
end