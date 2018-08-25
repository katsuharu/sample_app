onPageLoad 'users#index', ->
  entire_contents = document.getElementById('entire_contents')
  entire_contents.classList.remove 'container'
  $('body').addClass('bg_color')

onPageLoad 'users#index', ->
  buildTweet = (tweet) ->
    `var chat`
    # 投稿者の写真が登録されていない場合
    if tweet.img_url == null
      chat = $('.timeline-shows').prepend('<div class="flex_container tweet tweets" data-id=' + tweet.tweet.id + '>' + '<div class="tweet_img">' + '<div class="img_empty"></div>' + '</div>' + '<div class="tweet_text">' + '<div class="tweet_name">' + tweet.user_name + '</div>' + tweet.tweet.content + '<div class="flex_container tweet_data">' + '<div class="tweet_thread_mark">' + '<a href="/tweets/' + tweet.tweet.id + '" data-toggle="modal" data-target=".t_detail" data-remote="true"><i class="far fa-comment"></i></a>' + '</div>' + '<div class="thread_count_' + tweet.tweet.id + '">' + tweet.thread_count + '</div>' + '<div class="tweet_category">' + tweet.category_name + '</div>' + '<div class="tweet_at">' + tweet.post_at + '</div>' + '</div>' + '</div>' + '</div>')
    else
      chat = $('.timeline-shows').prepend('<div class="flex_container tweet tweets" data-id=' + tweet.tweet.id + '>' + '<div class="tweet_img">' + '<img src="' + tweet.img_url + '" alt="プロフィール画像" class="timeline_user_img">' + '</div>' + '<div class="tweet_text">' + '<div class="tweet_name">' + tweet.user_name + '</div>' + tweet.tweet.content + '<div class="flex_container tweet_data">' + '<div class="tweet_thread_mark">' + '<a href="/tweets/' + tweet.tweet.id + '" data-toggle="modal" data-target=".t_detail" data-remote="true"><i class="far fa-comment"></i></a>' + '</div>' + '<div class="thread_count_' + tweet.tweet.id + '">' + tweet.thread_count + '</div>' + '<div class="tweet_category">' + tweet.category_name + '</div>' + '<div class="tweet_at">' + tweet.post_at + '</div>' + '</div>' + '</div>' + '</div>')
    return

  update = ->
    `var tweet_id`
    if $('.flex_container.tweet')[0]
      # 先頭の'.flex_container .tweet'というクラスをともにもつタグの'id'というデータ属性を取得し、'tweet_id'という変数に代入
      tweet_id = $('.flex_container.tweet:first').data('id')
    else
      tweet_id = 0
    $.ajax(
      url: '/users/index'
      type: 'POST'
      dataType: 'json'
      data: 'id': tweet_id).always (data) ->
      #通信したら、成功の可否に関わらず（@new_tweets)を引数にとって以下のことを行う
      $.each data, (i, data) ->
        #'data'を'data'に代入してeachで回す
        buildTweet data
        #buildTweetを呼び出す
        return
      return
    return

  $ ->
    setInterval update, 6600
    # 6.6秒ごとにupdateという関数を実行する
    return
  return

onPageLoad 'users#check', ->
  entire_contents = document.getElementById('entire_contents')
  entire_contents.classList.remove 'container'
  $('body').addClass('bg_color')

  # timeline自動更新
  buildChat = (chat) ->
    `var chat`
    # 投稿者の写真が登録されていない場合
    if chat.img_url == null
      chat = $('.timeline-shows').prepend('<div class="flex_container tweet chats" data-id=' + chat.chat.id + '>' + '<div class="tweet_img">' + '<div class="img_empty"></div>' + '</div>' + '<div class="tweet_text">' + '<div class="tweet_name">' + chat.user_name + '</div>' + chat.chat.text + '<div class="flex_container tweet_data">' + '<div class="tweet_at">' + chat.post_at + '</div>' + '</div>' + '</div>' + '</div>')
    else
      chat = $('.timeline-shows').prepend('<div class="flex_container tweet chats" data-id=' + chat.chat.id + '>' + '<div class="tweet_img">' + '<img src="' + chat.img_url + '" alt="Data uri" class="timeline_user_img">' + '</div>' + '<div class="tweet_text">' + '<div class="tweet_name">' + chat.user_name + '</div>' + chat.chat.text + '<div class="flex_container tweet_data">' + '<div class="tweet_at">' + chat.post_at + '</div>' + '</div>' + '</div>' + '</div>')
    return
  
  update = ->
    `var chat_id`
    # マッチングペアのidを取得
    pair_id = $('.timeline-shows').data('pair_id')
    if $('.chats')[0]
      #もし'messages'というクラスがあったら
      #一番最後にある'chats'というクラスの'id'というデータ属性を取得し、'chat_id'という変数に代入
      chat_id = $('.chats:first').data('id')
    else
      chat_id = 0
    $.ajax(
      url: '/users/check'
      type: 'POST'
      dataType: 'json'
      data:
        'id': chat_id
        'pair_id': pair_id).always (data) ->
      #通信したら、成功しようがしまいが受け取ったデータ（@new_chat)を引数にとって以下のことを行う
      $.each data, (i, data) ->
        #'data'を'data'に代入してeachで回す
        buildChat data
        #buildChatを呼び出す
        return
      return
    return

  $ ->
    setInterval update, 6600
    # 6.6秒ごとにupdateという関数を実行する
    return