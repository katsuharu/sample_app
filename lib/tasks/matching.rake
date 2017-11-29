namespace :matching do
  task :execute => :environment do  | task |

    users = User.where.not(category_id: nil).where(pair_id: nil).where(any_category: 1)
    user_num = users.count #未マッチングユーザーの合計数を算出
    user_ids = Array.new(user_num)
    for i in 0..user_num - 1
      user_ids << users[i].id #配列usersに一人一人のidを代入
    end

    amari = user_num % 3
    shou = user_num / 3


  #「エントリーボタン」も押せなくする(翌日の00:00から再びボタンを押せるようにする。)。

  end

  task reset: :environment do
  end
end