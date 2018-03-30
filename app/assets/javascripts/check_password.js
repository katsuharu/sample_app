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
})