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
});