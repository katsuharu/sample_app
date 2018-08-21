$(document).ready(function (){
	function buildChat(chat) {
	  // 投稿者の写真が登録されていない場合
	  if (chat.chat.img_url == null) {
	    var chat = $('.timeline-shows').prepend(
	      '<div class="flex_container tweet chats" data-id=' + chat.chat.chat.id + ' data-pair_id=' + chat.chat.chat.pair_id + '>'
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
	      '<div class="flex_container tweet chats" data-id=' + chat.chat.chat.id + ' data-pair_id=' + chat.chat.chat.pair_id + '>'
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

	function send_mail(chat) {
	  $.ajax({
	      url: '/chats/send_mail',
	      type: 'POST',
	      dataType: 'json',
	      data:{
	        'user_id': chat.chat.chat.user_id,
	        'pair_id': chat.chat.chat.pair_id,
	      },
	  })
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
				  		'pair_id': $('[name="pair_id"').val(),
				  	}
				  }
				}).done(function(data) {
					buildChat(data)
					send_mail(data)
				}).fail(function(data) {
				})
			}
		}
	})

	$(document).on('click', '#chat_submit', function() {
		text = $('#chat_text').val()
		$.ajax({
		  type: 'POST',
		  url: '/chats/create',
		  data:{
		  	'chat': {
		  		'text': text,
		  		'pair_id': $('[name="pair_id"').val(),
		  	}
		  }
		}).done(function(data) {
			buildChat(data)
			send_mail(data)
		}).fail(function(data) {
		})
	})
})