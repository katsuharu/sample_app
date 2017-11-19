class StaticPagesController < ApplicationController
  def home
  	if logged_in?
  		@users = User.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def waiting
  end
end
