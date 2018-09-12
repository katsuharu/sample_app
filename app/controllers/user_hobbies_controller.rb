class UserHobbiesController < ApplicationController
  before_action :logged_in_user, only: [:hobby, :hobby_save, :edit, :del_hobby]

  def hobby
    @hobby = UserHobby.new
    # ログインユーザーが存在する場合
    if current_user.present?
      # オールジャンル以外の登録したUserHobbyモデルを取得
      @hobbies = UserHobby.where(user_id: current_user.id).where.not(hobby_name: 'オールジャンル')
    end
    @first_categories = FirstCategory.pluck(:id, :name)
    # SecondCategoryモデルを取得
    @second_categories = SecondCategory.all
    # @second_categories = SecondCategory.pluck(:id, :name, :first_category_id)
    # @third_categories = ThirdCategory.pluck(:id, :name, :second_category_id)
    # @forth_categories = ForthCategory.pluck(:id, :name, :third_category_id)

    # UserHobbyを取得
    @my_hobbies = UserHobby.where(user_id: current_user.id)
  end

  def hobby_save
    hobby_num = params[:user_hobby][:hobby_name].count()

    for i in 0..hobby_num - 1
      if params[:user_hobby][:hobby_name][i].empty?
      else
        @hobby = UserHobby.create(:hobby_name => params[:user_hobby][:hobby_name][i], :user_id => current_user.id)
      end
    end
    User.find_by(id: current_user.id).update_attribute(:hobby_added, 1)
    flash[:success] = "趣味を登録いたしました。"
    redirect_to root_url
  end

  # 既存の登録済みのUserHobbyを全て削除し、新たに送られたパラメータでUserHobbyを作り直すメソッド
  def edit
    begin
      # 登録済みUserHobbyを削除
      UserHobby.where(user_id: current_user.id).delete_all
      # 選択したカテゴリーの数分繰り返す
      params[:user_hobby].each do |user_hobby|
        # UserHobbyを作成
        UserHobby.create(hobby_id: user_hobby[:hobby_id], hobby_name: user_hobby[:hobby_name], user_id: current_user.id)
      end
      flash[:success] = "趣味を登録いたしました。"
      redirect_to hobby_path
    rescue
      p e
    end
  end

  def del_hobby
    params[:user_hobbies][:id].each do |id| 
      UserHobby.find(id).destroy()
    end
    flash[:success] = "趣味を削除いたしました。"
    redirect_to hobby_show_path
  end
end