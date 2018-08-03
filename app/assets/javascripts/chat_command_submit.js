$(document).ready(function (){
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
				}).fail(function(data) {
				})
			}
		}
	})
})