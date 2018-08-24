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
      lunches.each do |lunch|
        user = User.where(deleted_at: nil).find_by(id: lunch.user_id)
        if user.present?
          begin
            # メール送信
            user.send_fail_email
            # sent_atカラムを更新
            lunch.update_attribute(:sent_at, DateTime.now)
          rescue => e
            # 例外のクラス名、エラーメッセージ、バックトレースをターミナルに出力
            puts "#{e.class}:#{e.message}"
            puts e.backtrace
          end
        end
      end
    end

    def success_mail(lunches)
      lunches.each do |lunch|
        user = User.where(deleted_at: nil).find_by(id: lunch.user_id)
        if user.present?
          begin
            # メール送信
            user.send_success_email
            # sent_atカラムを更新
            lunch.update_attribute(:sent_at, DateTime.now)
          rescue => e
            # 例外のクラス名、エラーメッセージ、バックトレースをターミナルに出力
            puts "#{e.class}:#{e.message}"
            puts e.backtrace
          end
        end
      end
    end
end