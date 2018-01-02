class StaticPagesController < ApplicationController
  def home
  	if logged_in?
      @users = User.where.not(category_id: nil)
    end
  end

  def entry

  end

  def contact
  end

  def waiting
  end

  def send_mail
    UserMailer.contact_contents(contact_params).deliver_now
    flash[:success] = "送信が完了しました。"
    redirect_to :action => "contact"
  end

  private

    def contact_params
      params.require(:contact).permit(:name,
                                      :email,
                                      :content,
                                      )
    end
    
end