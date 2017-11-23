class StaticPagesController < ApplicationController
  def home
  	if logged_in?
  		@users = User.where.not(entry_id: nil).paginate(page: params[:page])
    end
  end

  def contact
  end

  def waiting
  end

  def send_mail
    ContactMailer.contact_contents(contact_params).deliver_now
    flash[:success] = "送信が完了しました。"
    redirect_to :action => "contact"
  end
end
