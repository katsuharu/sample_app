class StaticPagesController < ApplicationController
  def home
  	if logged_in?
  		@users = User.where.not(entry_id: nil).paginate(page: params[:page])
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
