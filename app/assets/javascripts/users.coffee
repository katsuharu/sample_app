onPageLoad 'users#index', ->
  entire_contents = document.getElementById('entire_contents')
  entire_contents.classList.remove 'container'
  $('body').addClass('bg_color')


# マッチング相手確認画面チャット更新
onPageLoad 'users#check', ->
  entire_contents = document.getElementById('entire_contents')
  entire_contents.classList.remove 'container'
  $('body').addClass('bg_color')

  # timeline自動更新
  buildChat = (chat) ->
    `var chat`
    # 投稿者の写真が登録されていない場合
    if chat.img_url == null
      chat = $('.timeline-shows.pair_chats').prepend('<div class="flex_container tweet chats" data-id=' + chat.chat.id + '>' + '<div class="tweet_img">' + '<div class="img_empty"></div>' + '</div>' + '<div class="tweet_text">' + '<div class="tweet_name">' + chat.user_name + '</div>' + chat.chat.text + '<div class="flex_container tweet_data">' + '<div class="tweet_at">' + chat.post_at + '</div>' + '</div>' + '</div>' + '</div>')
    else
      chat = $('.timeline-shows.pair_chats').prepend('<div class="flex_container tweet chats" data-id=' + chat.chat.id + '>' + '<div class="tweet_img">' + '<img src="' + chat.img_url + '" alt="Data uri" class="timeline_user_img">' + '</div>' + '<div class="tweet_text">' + '<div class="tweet_name">' + chat.user_name + '</div>' + chat.chat.text + '<div class="flex_container tweet_data">' + '<div class="tweet_at">' + chat.post_at + '</div>' + '</div>' + '</div>' + '</div>')
    return
  
  update = ->
    `var chat_id`
    # マッチングペアのidを取得
    pair_id = $('.timeline-shows.pair_chats').data('pair_id')
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