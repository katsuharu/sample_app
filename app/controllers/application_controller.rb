class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  	#ログイン済みユーザーかどうか確認
  	def logged_in_user
      if logged_in?
        # current_user.update_attribute(:logined_at, DateTime.now)
      else
  	    store_location
  	    flash[:danger] = "ログインしてください"
  	    redirect_to login_url
  	  end
  	end

    def hobby_registered
      if current_user
        if current_user.hobby_added == nil
          redirect_to hobby_path
        end
      end
    end
  	
end