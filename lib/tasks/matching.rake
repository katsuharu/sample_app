namespace :matching do
  task :execute => :environment do  | task |

    @users = User.where.not(category_id: nil).where(pair_id: nil).where(any_category: 1)
    user_num = @users.count
    #「エントリーボタン」も押せなくする(翌日の00:00から再びボタンを押せるようにする。)。
    k = user_num % 3
  end

  task reset: :environment do
  end
end