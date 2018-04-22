namespace :matching do
  task :execute => :environment do  | task |
    desc "ペアを作成"
    #Lunchテーブルから今日開催されているカテゴリーを重複なく全て取得
    $pair_id = 0
    
    today_category_ids = Lunch.where(lunch_date: Date.today).pluck(:category_id).uniq
    # today_category_ids = Lunch.where(lunch_date: Date.yesterday).pluck(:category_id).uniq

    entry_users = Array.new
    user_ids = Array.new
    # 全カテゴリーについて、各カテゴリーにエントリーしているエントリーユーザーを取得。
    today_category_ids.each_with_index do |c_id, i|
      entry_users[i] = User.where(category_id: c_id) #各エントリーカテゴリーごとのユーザーを配列で取得
      # user_ids.push(entry_users[i].pluck(:id))
    end

    entry_users.each do |entry_u|
      make_pair(entry_u, entry_u.pluck(:id))
    end
  end

  # カテゴリー毎の全エントリーユーザーのidの配列
  def make_pair(e_users, user_ids)
    entry_num = e_users.count
    remainder = entry_num % 3 #エントリー数を3で割った余り
    quotient = entry_num / 3    #エントリー数を3で割った商

    if entry_num == 0 || entry_num == 1
      #このカテゴリーではペアなし
      e_users.each do |user| 
        user.send_fail_email #マッチング不成立のメールを送信
      end
    elsif entry_num == 2 || entry_num == 3 || entry_num == 4 || entry_num == 5
      $pair_id = $pair_id + 1
      e_users.update_all(pair_id: $pair_id)
      # User.where("(id = ?) OR (id = ?)",user_ids.shift ,user_ids.shift).update_all(pair_id: 1)
      e_users.each do |user| 
        user.send_success_email #マッチング成立のメールを送信
      end
    else
      #3人のペアを quotient数ぶん作る。
      user_ids = user_ids.shuffle #エントリーユーザーのidをシャッフル

      for i in 1..quotient do
        $pair_id = $pair_id + 1
        User.where("(id = ?) OR (id = ?) OR (id = ?)",user_ids.shift ,user_ids.shift ,user_ids.shift).update_all(pair_id: $pair_id)
      end

      case remainder
      when 0
      when 1
        #そのペアのうちの一つだけ1人足して4人のペアを1つ作る
        User.where("(id = ?)", user_ids.shift).update_attribute(:pair_id, $pair_id)
      when 2
        #そのペアのうちの2つ1人足して4人のペアを2つ作る
        User.where("(id = ?)", user_ids.shift).update_attribute(:pair_id, $pair_id -1)
        User.where("(id = ?)", user_ids.shift).update_attribute(:pair_id, $pair_id)
      end

      e_users.each do |user| 
        user.send_success_email #マッチング成立のメールを送信
      end
    end #if entry_num == 0 || entry_num == 1
  end

end