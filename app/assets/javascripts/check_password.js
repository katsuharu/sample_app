$(document).on('turbolinks:load', function() {
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
	    // $('body').prepend('<img alt="LF" src="/assets/loading.gif" id="loading_img">')
	    $('body').prepend('<img src="/loading_img/loading.gif" alt="Loading Image" id="loading_img">')
	})

	// Infinite Scroll
	$(".timeline-shows").infinitescroll({
	    loading: {
	      img: "/loading_img/loading.gif",
	      msgText: "loading..."
	    },
	    navSelector: "nav.pagination",
	    nextSelector: "nav.pagination a[rel=next]",
	    itemSelector: ".timeline-shows div.tweet"
	})

	// selectのラベルを更新
	$('select#tweet_category_id').on('change', function(){
	  var $this = $(this)
	  var $option = $this.find('option:selected')
	  $('.select_label').text($option.text())
	  $this.blur();
	})

})