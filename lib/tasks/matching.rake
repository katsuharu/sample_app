namespace :matching do
  task :execute, ['time_zone_id'] => :environment do  | task, args |
    k = @@entry_id % 3
    case k
      when 0 #余りが0人

      when 1  #余りが一人。最新のペアに追加しちゃう。
        User.where(entry_id: @@entry_id).update(pair_id: @@pair_no)
      when 2 #余りの二人で組みを作る。
        @@pair_no += 1 
        User.where(entry_id: @@entry_id-1 .. @@entry_id).update(pair_id: @@pair_no)
    end


    #「エントリーボタン」も押せなくする(翌日の00:00から再びボタンを押せるようにする。)。
   
  end


  task reset: :environment do
  end
end