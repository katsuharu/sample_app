$(document).ready(function (){
  function buildChat(chat) {
    // 投稿者の写真が登録されていない場合
    if (chat.chat.img_url == null) {
      var chat = $('.timeline-shows').prepend(
        '<div class="flex_container tweet chats" data-id=' + chat.chat.chat.id + '>'
        + '<div class="tweet_img">'
        + '<div class="img_empty"></div>'
        + '</div>'
        + '<div class="tweet_text">'
        + '<div class="tweet_name">'
        + chat.chat.user_name
        + '</div>'
        + chat.chat.chat.text
        + '<div class="flex_container tweet_data">'
        + '<div class="tweet_at">'
        + chat.chat.post_at
        + '</div>'
        + '</div>'
        + '</div>'
        + '</div>'
      )
    } else {
      var chat = $('.timeline-shows').prepend(
        '<div class="flex_container tweet chats" data-id=' + chat.chat.chat.id + '>'
        + '<div class="tweet_img">'
        + '<img src="' + chat.chat.img_url + '" alt="Data uri" class="timeline_user_img">'
        + '</div>'
        + '<div class="tweet_text">'
        + '<div class="tweet_name">'
        + chat.chat.user_name
        + '</div>'
        + chat.chat.chat.text
        + '<div class="flex_container tweet_data">'
        + '<div class="tweet_at">'
        + chat.chat.post_at
        + '</div>'
        + '</div>'
        + '</div>'
        + '</div>'
      )
    }
  }

  $(document).on('keydown', '#chat_text', function(e){
    if(e.metaKey && e.keyCode === 13){
      if((text = $('#chat_text').val()) != ''){
        $.ajax({
          type: 'POST',
          url: '/chats/create',
          data:{
            'chat': {
              'text': text,
              'pair_id': $('[name="chat[pair_id]"').val(),
            }
          }
        }).done(function(data) {
          // 投稿フォームの入力を消去
          $('textarea[name="chat[text]"]').val('')
          // 投稿内容を画面に動的表示
          buildChat(data)
        }).fail(function(data) {
        })
      }
    }
  })

  // // clickイベントでの処理（mouseenter は省略）
  // // var clickEventType=((window.ontouchstart!==null)?'click':'touchstart');
  // // $("#chat_submit").on(clickEventType, function() {
  //   // console.log(clickEventType)
  //   // クリック、タップ時の処理を記述
  // // $('#chat_submit').on('click', function(){
  // $(document).on('click', '#chat_submit', function(e) {
  //   e.preventDefault()
  //   text = $('#chat_text').val()
  //   console.log(text)
  //   // テキストフォームが空でない場合
  //   if(text != '') {
  //     $.ajax({
  //       type: 'POST',
  //       url: '/chats/create',
  //       data:{
  //         'chat': {
  //           'text': text,
  //           'pair_id': $('[name="pair_id"').val(),
  //         }
  //       }
  //     }).done(function(data) {
  //       // 投稿フォームの入力を消去
  //       $('textarea[name="chat[text]"]').val('')
  //       // 投稿内容を画面に動的表示
  //       buildChat(data)
  //     })
  //   }
  // })
})