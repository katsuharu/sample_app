namespace :lunch_theme_notification do
  task :lunch_theme_notification => :environment do  | task |
    desc "notify today's lunch theme"
    p Time.now.to_s + 'lunch_theme_notification start'
    
    # 本日のランチテーマのカテゴリIDを取得
    if daily_lunch = DailyLunch.find_by(date: Date.today)
      category_id = daily_lunch.category_id
      # カテゴリ名を取得
      category_name = Category.find(category_id).name
      # カテゴリに合致するhobbyを登録しているユーザーのメールアドレスを配列で取得
      user_ids = UserHobby.where(hobby_id: category_id).pluck(:user_id)
      email_lists = User.where(id: user_ids).pluck(:email)
      while email_lists.present?
        # メールの配列から先頭100件を取り出しランチテーマの通知をBCCで一斉送信
        DailyLunch.notify_lunch_theme(email_lists.slice!(0..99), category_name)
      end
      p Time.now.to_s + 'lunch_theme_notification end'
    else
      p Time.now.to_s + 'Today no lunch lunch_theme_notification end'
    end
  end

  private
end