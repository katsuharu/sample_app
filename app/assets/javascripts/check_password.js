$(document).ready(function (){
	// 以前にアップロードした画像が存在する場合
	if($('.vanish').attr('src')) {
		$('#user_profile_img').removeAttr("required")
	} else {
		console.log('NONOJO')
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
	    $('body').prepend('<img alt="Lunch Friends logo" src="/assets/loading.gif" id="loading_img">')
	})

})