$(document).ready(function (){
	// 以前にアップロードした画像が存在する場合、画像のアップロードの必須化を解除
	if($('.vanish').attr('src')) {
		$('#user_profile_img').removeAttr("required")
	} else {
	}

	$(document).on('click', '#submitBtn', function() {
		if ($('#user_password').val() != $('#user_password_confirmation').val()) {
			alert('パスワードと確認用パスワードが一致しません。')
			return false		
		}
	})

	// 確認画面で登録ボタン押下時に処理中であることを表示
	$(document).on('click', '#register_user', function() {
	    $('body').attr('id', 'progressing');
	    $('body').prepend('<img alt="LF" src="http://www.mytreedb.com/uploads/mytreedb/loader/ajax_loader_blue_256.gif" id="loading_img">')
	})

	$(document).on('click', 'img.footer_triangle', function() {
		if($('footer').is(':visible')) {
			$('footer').hide()
		} else {
			$('footer').show()
		}
	})

	// Infinite Scroll
	$(".timeline-shows").infinitescroll({
	    loading: {
	      img:     "http://www.mytreedb.com/uploads/mytreedb/loader/ajax_loader_blue_48.gif",
	      msgText: "loading..."
	    },
	    navSelector: "nav.pagination",
	    nextSelector: "nav.pagination a[rel=next]",
	    itemSelector: ".timeline-shows div.tweet"
	})
})