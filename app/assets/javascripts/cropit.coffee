$(document).on 'turbolinks:load', () ->
  $('#image-cropper').cropit imageBackground: true
  $('#user_form').on 'submit', ->
    imageData = $('#image-cropper').cropit('export')
    $('#user_avatar_data_uri').val(imageData)
    $('#user_avatar').replaceWith($('#user_avatar').clone())