namespace :matching do
  task :execute => :environment do  | task |

    #未ッマッチングユーザーとそのid情報を取得
    users = User.where.not(category_id: nil).where(pair_id: nil).where(any_category: 1).select(:id)
    user_num = users.count #未マッチングユーザーの合計数を算出
    user_ids = Array.new(user_num)
    pair_id = 0;
    
    for i in 0..user_num - 1
      user_ids << users[i].id #配列usersに一人一人のidを代入
    end

    amari = user_num % 3
    shou = user_num / 3

    case amari
      when 0
        for i in 0..shou - 1
          User.where(id: users[i].id).where(pair_id: nil).update(pair_id: i)
          User.where(id: users[i+1].id).where(pair_id: nil).update(pair_id: i)
          User.where(id: users[i+2].id).where(pair_id: nil).update(pair_id: i)
        end

      when 1
        for i in 0..shou - 2
          User.where(id: users[i].id).where(pair_id: nil).update(pair_id: i)
          User.where(id: users[i+1].id).where(pair_id: nil).update(pair_id: i)
          User.where(id: users[i+2].id).where(pair_id: nil).update(pair_id: i)
        end
      when 2
        for i in 0..shou - 1
          User.where(id: users[i].id).where(pair_id: nil).update(pair_id: i)
          User.where(id: users[i+1].id).where(pair_id: nil).update(pair_id: i)
          User.where(id: users[i+2].id).where(pair_id: nil).update(pair_id: i)
        end
  end

  #「エントリーボタン」も押せなくする(翌日の00:00から再びボタンを押せるようにする。)。

  task reset: :environment do
  end
end