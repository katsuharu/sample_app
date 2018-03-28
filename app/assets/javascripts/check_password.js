$(document).ready(function (){
	$(document).on('click', '#submitBtn', function() {
		if ($('#user_password').val() != $('#user_password_confirmation').val()) {
			alert('パスワードと確認用パスワードが一致しません。')
			return false		
		}
	})
})