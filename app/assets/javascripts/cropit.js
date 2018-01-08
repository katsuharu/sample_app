$(document).on('turbolinks:load', function() {
	$('#image-cropper').cropit();

	// When user clicks select image button,
	// open select file dialog programmatically
	$('.select-image-btn').click(function() {
	  $('.cropit-image-input').click();
	});

	// Handle rotation
	$('.rotate-cw-btn').click(function() {
	  $('#image-cropper').cropit('rotateCW');
	});
	$('.rotate-ccw-btn').click(function() {
	  $('#image-cropper').cropit('rotateCCW');
	});

	$('#user_form').on('submit', function() {
	  var imageData;
	  imageData = $('#image-cropper').cropit('export');
	  $('#user_profile_img_data_uri').val(imageData);
	  return $('#user_profile_img').replaceWith($('#user_profile_img').clone());
	});
});