namespace :matching do
  task :execute => :environment do  | task |
    
    cate_cnt = Category.count #カテゴリー数
    cate_new = cate_cnt + 1 #現在ある最大のカテゴリー番号に1足したものを、ユーザーのカテゴリーIDとする
    cate_surplus = Array.new(cate_cnt)
    for i in 0..cate_cnt - 1
      cate_all += 1 #各カテゴリー毎のあまりの人数を合計して、全ての余りの人数を算出
    end

    #すべての余りの合計数を3で割る。

    #「エントリーボタン」も押せなくする(翌日の00:00から再びボタンを押せるようにする。)。
   
  end


  task reset: :environment do
  end
end