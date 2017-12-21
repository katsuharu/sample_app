$(document).on('turbolinks:load', function() {
	if($('#user_category_id').val() == ''){
		console.log("no selected");
	} else {
		console.log("selected");
	}
});