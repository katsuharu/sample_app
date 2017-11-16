class MicropostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user,   only: :destroy
	
	def create
		@micropost = current_user.microposts.build(micropost_params)
	    if @micropost.save
	    	flash[:success] = "Micropost created!"
	    	redirect_to root_url
	    else
	    	@feed_items = []
	     	render 'static_pages/home'
	    end
	end

	def destroy
	    @micropost.destroy
	    flash[:success] = "投稿が削除されました。"
	    redirect_to request.referrer || root_url
	end

	private

		def micropost_params
	    	params.require(:micropost).permit(:content, :picture)
	    end

end