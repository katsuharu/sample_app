class ApplesController < ApplicationController
	def index
		@apple = Tweet.new
		@apples = Tweet.all
	end

	

	def create
		@apples = Tweet.all
		@apple = Tweet.new(apple_params)
		respond_to do |format|
			if @apple.save
				format.html
				format.js
			else
				format.js {render :new}
			end
		end
	end

	

	private
		def apple_params
			params.require(:tweet).permit(:content)
		end

		
end