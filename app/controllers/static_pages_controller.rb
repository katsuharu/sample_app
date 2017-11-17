class StaticPagesController < ApplicationController
  def home
  	if logged_in?
  		@entry_users = current_user.entry_user.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
