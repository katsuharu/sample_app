onPageLoad 'users#index', ->
  entire_contents = document.getElementById('entire_contents')
  entire_contents.classList.remove 'container'
  $('body').addClass('bg_color')

onPageLoad 'users#check', ->
  entire_contents = document.getElementById('entire_contents')
  entire_contents.classList.remove 'container'
  $('body').addClass('bg_color')


  buildChat = (chat) ->
    `var chat`
    chat = $('.timeline-shows').prepend('<div class="flex_container tweet chats" data-id=' + chat.chat.id + ' data-pair_id=' + chat.chat.pair_id + '>' + '<div class="tweet_img">' + '<img src="' + chat.img_url + '" alt="Data uri" class="timeline_user_img">' + '</div>' + '<div class="tweet_text">' + '<div class="tweet_name">' + chat.user_name + '</div>' + chat.chat.text + '<div class="flex_container tweetet_data">' + '<div class="tweet_at">' + chat.post_at + '</div>' + '</div>' + '</div>' + '</div>')
    return

  update = ->
    `var chat_id`
    if $('.chats')[0]
      #もし'messages'というクラスがあったら
      #一番最後にある'chats'というクラスの'id'というデータ属性を取得し、'chat_id'という変数に代入
      chat_id = $('.chats:first').data('id')
      # マッチングペアのidを取得
      pair_id = $('.chats:first').data('pair_id')
    else
      chat_id = 0
    $.ajax(
      url: '/users/check'
      type: 'POST'
      dataType: 'json'
      data:
        'id': chat_id
        'pair_id': pair_id).always (data) ->
      #通信したら、成功しようがしまいが受け取ったデータ（@new_message)を引数にとって以下のことを行う
      $.each data, (i, data) ->
        #'data'を'data'に代入してeachで回す
        buildChat data
        #buildChatを呼び出す
        return
      return
    return

  $ ->
    setInterval update, 6600
    #10秒ごとにupdateという関数を実行する
    return
  return