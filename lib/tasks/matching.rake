namespace :matching do
  task :execute => :environment do  | task |

    #未ッマッチングユーザーとそのid情報を取得
    users = User.where.not(category_id: nil).where(pair_id: nil).where(any_category: 1).select(:id, :pair_id)
    user_num = users.count #未マッチングユーザーの合計数を算出
    user_ids = Array.new(user_num)
    pair_id = 0;

    for i in 0..user_num - 1
      user_ids << users[i].id #配列usersに一人一人のidを代入
    end

    amari = user_num % 3
    shou = user_num / 3

    #3で割ったあまりの数によってマッチングの組みを決定
    case amari
      when 0
        for i in 0..shou - 1
          User.where(id: users[i].id).where(pair_id: nil).update(pair_id: i)
          User.where(id: users[i+1].id).where(pair_id: nil).update(pair_id: i)
          User.where(id: users[i+2].id).where(pair_id: nil).update(pair_id: i)
        end

        p "0 amari matched"

      when 1
        for i in 0..shou - 2
          User.where(id: users[i].id).where(pair_id: nil).update(pair_id: pair_id)
          User.where(id: users[i+1].id).where(pair_id: nil).update(pair_id: pair_id)
          User.where(id: users[i+2].id).where(pair_id: nil).update(pair_id: pair_id)
          pair_id += 1
        end

        #残り一人のユーザーのpair_idを最後に生成された組みのpair_idに更新
        User.where.not(category_id: nil).where(pair_id: nil).where(any_category: 1).update(pair_id: pair_id)

        p "1 amari matched"
      when 2
        for i in 0..shou - 1
          User.where(id: users[i].id).where(pair_id: nil).update(pair_id: pair_id)
          User.where(id: users[i+1].id).where(pair_id: nil).update(pair_id: pair_id)
          User.where(id: users[i+2].id).where(pair_id: nil).update(pair_id: pair_id)
          pair_id += 1  
        end

        #残り二人のユーザーにpair_idを更新
        User.where.not(category_id: nil).where(pair_id: nil).where(any_category: 1).update_all(pair_id: pair_id)

        p "2 amari matched"
    end

    #「エントリーボタン」も押せなくする(翌日の00:00から再びボタンを押せるようにする。)。
    #ユーザーにマッチングの結果をメールで送信
  end

  task reset: :environment do
  end
end