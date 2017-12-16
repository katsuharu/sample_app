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
      $('#user_avatar_data_uri').val(imageData)
      $('#user_avatar').replaceWith($('#user_avatar').clone())