$(document).on('turbolinks:load', function() {
$('#image-cropper').cropit();

$('#user_form').on('submit', function() {
  var imageData;
  imageData = $('#image-cropper').cropit('export');
  $('#user_avatar_data_uri').val(imageData);
  return $('#user_avatar').replaceWith($('#user_avatar').clone());
});
});