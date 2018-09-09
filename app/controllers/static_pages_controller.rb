class StaticPagesController < ApplicationController
  def contact
    @user = current_user
  end

  def send_mail
    UserMailer.contact_contents(contact_params).deliver_now
    flash[:success] = "送信が完了しました。"
    redirect_to root_url
  end

  private

    def contact_params
      params.require(:contact).permit(:name,:email,:content)
    end
end