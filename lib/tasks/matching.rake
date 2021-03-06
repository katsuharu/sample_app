namespace :matching do
  task :matching => :environment do  | task |
    desc "making lunch pairs"
    p Time.now.to_s + 'matching start'
    # ペアのナンバリング用のグローバル変数を定義
    $pair_id = 0
    # 本日のキャンセルされていないエントリ中の結果メール未送信のLunchモデルのcategory_idを重複なく全て取得する
    today_category_ids = Lunch.where(lunch_date: Date.today).where(canceled_at: nil).where(sent_at: nil).pluck(:category_id).uniq
    today_category_ids.each do |category_id|
      lunches = Lunch.where(category_id: category_id).where(lunch_date: Date.today).where(canceled_at: nil).where(sent_at: nil)
      # カテゴリー毎のエントリーユーザー数を取得
      entry_numbers = lunches.count

      # エントリー数が2人以上の場合
      if entry_numbers > 1
        # エントリーカテゴリー毎にペアを作成
        make_pair(lunches)
      else
        # ペアを作成せず、エントリーユーザーにマッチング不成立のメールを送信する
        fail_mail(lunches)
      end
    end

    p Time.now.to_s + 'matching end'
  end

  private

    # エントリ中のユーザーでマッチングペアを作成するメソッド
    # param lunches あるカテゴリーの開催中のLunchモデルの配列
    def make_pair(lunches)
      entry_num = lunches.count
      remainder = entry_num % 3 #エントリー数を3で割った余り
      quotient = entry_num / 3    #エントリー数を3で割った商
      # エントリー数が2~5人の場合
      if entry_num <= 5
        # pair_idをカウントアップ
        $pair_id = $pair_id + 1
        lunches.update_all(pair_id: $pair_id)
        # マッチング成立のメールを送信
        success_mail(lunches)
      else
        #3人のペアを quotient数ぶん作る。
        # 開催中のLunchモデルのidの配列を取得 
        lunch_ids = lunches.pluck(:id)
        # Lunchモデルのidの配列をランダムに並べた配列を取得
        id_shuffles = lunch_ids.shuffle
        for i in 1..quotient do
          # pair_idをカウントアップ
          $pair_id = $pair_id + 1
          Lunch.where(id: [id_shuffles.shift, id_shuffles.shift, id_shuffles.shift]).update_all(pair_id: $pair_id)
        end

        # 3で割った余りの数で場合分け
        case remainder
        # 余りが1の場合
        when 1
          # pair_idの値が最大のペアに1人足して4人のペアを作る
          Lunch.where(id: [id_shuffles.shift]).update_all(pair_id: $pair_id)
        # 余りが2の場合
        when 2
          # pair_idの値がトップ1,2位のペアそれぞれに1人足して4人のペアを2つ作る
          Lunch.where(id: [id_shuffles.shift]).update_all(pair_id: $pair_id - 1)
          Lunch.where(id: [id_shuffles.shift]).update_all(pair_id: $pair_id)
        end

        #マッチング成立のメールを送信
        success_mail(lunches)
      end
    end

    def fail_mail(lunches)
      # 参加ユーザーのメアドの配列を取得
      email_lists = User.where(id: lunches.pluck(:user_id)).pluck(:email)
      # 配列に要素が存在する場合
      while email_lists.present?
        # 配列から先頭100件をとり出してメール送信を実行
        Lunch.send_fail_email(email_lists.slice!(0..99))
      end
      lunches.update_all(sent_at: DateTime.now)
    end

    def success_mail(lunches)
      # 参加ユーザーのメアドの配列を取得
      email_lists = User.where(id: lunches.pluck(:user_id)).pluck(:email)
      # 配列に要素が存在する場合
      while email_lists.present?
        # 配列から先頭100件をとり出してメール送信を実行
        Lunch.send_success_email(email_lists.slice!(0..99))
      end
      lunches.update_all(sent_at: DateTime.now)
    end
end