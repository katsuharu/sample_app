$(document).on 'turbolinks:load', () ->
    $('#image-cropper').cropit()

    $('.rotate-cw-btn').click ->
      $('#image-cropper').cropit 'rotateCW'
      return
    $('.rotate-ccw-btn').click ->
      $('#image-cropper').cropit 'rotateCCW'
      return

    $('#user_form').on 'submit', ->
      imageData = $('#image-cropper').cropit('export')
      $('#user_profile_img_data_uri').val(imageData)
      $('#user_profile_img').replaceWith($('#user_profile_img').clone())