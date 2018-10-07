module LunchModule

  def displayLunchCard
    ########## TOPタイムライン #########
    # # 投稿フォームのカテゴリーセレクト用のハッシュを定義
    # @tw_selects = {"オールジャンル" => 43}
    ##################

    ########## ユーザーの登録したカテゴリー ############
    # # # ランチカードの配列。初期値としてオールジャンルカテゴリーを代入
    # # @cards = [{category_id: 43,
    # #           category_name: 'オールジャンル',
    # #           users: User.where(id: Lunch.get_entry_user_ids(43)), # オールジャンルにエントリー中のUserモデルの配列
    # #           can_entry: true
    # #           }]
    # @cards = [{category_id: 43,
    #           category_name: 'オールジャンル',
    #           is_others: Lunch.is_others(current_user.id, 43), # 他のユーザーが参加していればtrue、そうでなければfalse
    #           can_entry: true
    #           }]
    # # ログインユーザーが登録したカテゴリーの名前の配列を取得
    # user_cards = UserHobby.where(user_id: current_user.id).pluck(:hobby_name)
    # # 登録したカテゴリーの数分繰り返す
    # user_cards.each do |u_card|
    #   category = Category.find_by(name: u_card)
    #   # カテゴリーが存在する場合
    #   if category.present?
    #     # カテゴリーidを取得
    #     category_id = category.id
    #     # このカテゴリーにエントリー中の場合
    #     if @my_lunch.present? && category_id == @my_lunch.category_id
    #       # 自分が登録したカテゴリーのなかで登録ユーザー数が3人以上場合
    #       if UserHobby.where(hobby_name: u_card).count > 2
    #         ###########
    #         # ランチカードで一番最初に表示されるように配列の先頭にハッシュを追加
    #         # @cards.unshift(
    #         # {category_id: category_id, # カテゴリーID
    #         # category_name: u_card, # 3名以上のユーザーが登録したカテゴリーのカテゴリ名
    #         # users: User.where(id: Lunch.get_entry_user_ids(category_id)), # 各カテゴリーにエントリー中のUserモデルの配列
    #         # can_entry: true
    #         # })
    #         @cards.unshift(
    #         {category_id: category_id, # カテゴリーID
    #         category_name: u_card, # 3名以上のユーザーが登録したカテゴリーのカテゴリ名
    #         is_others: Lunch.is_others(current_user.id, category_id),
    #         can_entry: true
    #         })
    #         ######
    #       else
    #         # ランチカードで一番最初に表示されるように配列の先頭にハッシュを追加
    #         @cards.unshift(
    #         {category_id: category_id, # カテゴリーID
    #         category_name: u_card, # 3名以上のユーザーが登録したカテゴリーのカテゴリ名
    #         # users: User.where(id: Lunch.get_entry_user_ids(category_id)), # 各カテゴリーにエントリー中のUserモデルの配列
    #         is_others: Lunch.is_others(current_user.id, category_id),
    #         can_entry: false
    #         })
    #       end
    #     else
    #       if UserHobby.where(hobby_name: u_card).count > 2
    #         # 配列の末尾にハッシュを追加
    #         @cards.push(
    #         {category_id: category_id, # カテゴリーID
    #         category_name: u_card, # 3名以上のユーザーが登録したカテゴリーのカテゴリ名
    #         # users: User.where(id: Lunch.get_entry_user_ids(category_id)), # 各カテゴリーにエントリー中のUserモデルの配列
    #         is_others: Lunch.is_others(current_user.id, category_id),
    #         can_entry: true
    #         })
    #       else
    #         # 配列の末尾にハッシュを追加
    #         @cards.push(
    #         {category_id: category_id, # カテゴリーID
    #         category_name: u_card, # 3名以上のユーザーが登録したカテゴリーのカテゴリ名
    #         # users: User.where(id: Lunch.get_entry_user_ids(category_id)), # 各カテゴリーにエントリー中のUserモデルの配列
    #         is_others: Lunch.is_others(current_user.id, category_id),
    #         can_entry: false
    #         })
    #       end
    #     end
    #     # カテゴリーハッシュに追加
    #     @tw_selects[u_card] = category_id
    #   end
    # end
    ######################

    # @user = current_user
    # @user.update_attribute(:logined_at, DateTime.now)

    # # Timelineに投稿された場合
    # if params[:id].present?
    #   @new_tweets = []
    #   tweets = Tweet.where('id > ?', params[:id])
    #   tweets.each do |tweet|
    #     # 時刻の表示を整形
    #     # モデルの作成から1日以上経過している場合
    #     if Time.now - tweet.created_at >= 86400
    #       post_at = tweet.created_at.strftime("%Y年 %m月 %d日")
    #     else
    #       post_at = time_ago_in_words(tweet.created_at) + "前"
    #     end

    #     # カテゴリー名を取得
    #     category_name = Category.find_by(id: tweet.category_id).name if tweet.category_id.present?
    #     # 返信数を取得
    #     thread_count = TThread.where(tweet_id: tweet.id).count

    #     @new_tweets.push({ tweet: tweet, # Tweetモデル
    #                     img_url: tweet.user.profile_img.url, # 投稿者のimg_URL
    #                     user_name: tweet.user.name, # 投稿者名
    #                     post_at: post_at, # 投稿時刻(表示用に整形済)
    #                     category_name: category_name, # カテゴリー名
    #                     thread_count: thread_count, # 返信数
    #                   })
    #   end
    #   respond_to do |format| 
    #     format.html # html形式でアクセスがあった場合は特に何もなし
    #     format.json { @new_tweets }
    #   end
    # end
  end

  module_function :displayLunchCard
end