namespace :matching do
  task :execute => :environment do  | task |
    
    cate_cnt = Category.count #カテゴリー数
    cate_surplus = Array.new(cate_cnt)
    for i in 1..cate_cnt

      #各カテゴリーでペアを作った後のあまりの数を求める
    end

    k = num % 3 #3人組を作り終わった後に余る人数
    case k
      when 0 #余りが0人
      	p "完全なペア"
      when 1  #余りが一人。最新のペアに追加しちゃう。
        User.where(entry_id: num).update(pair_id: pair)
      	p "余り一人を足したペア"
      when 2 #余りの二人で組みを作る。
        pair += 1 
        User.where(entry_id: num-1 .. num).update(pair_id: pair)
        p "二人ペア"
    end


    #「エントリーボタン」も押せなくする(翌日の00:00から再びボタンを押せるようにする。)。
   
  end


  task reset: :environment do
  end
end