$(document).on('turbolinks:load', function() {
  // 入力したパスワードと確認パスワードが一致しないときにsubmitを無効化する
  $('#submitBtn').on('click',function(){
    if ($('#user_password').val() != $('#user_password_confirmation').val()) {
      alert('パスワードと確認用パスワードが一致しません。')
      return false
    }
  })

  // 確認画面で登録ボタン押下時に処理中であることを表示
  $('#register_user').on('click',function(){
    $('body').attr('id', 'progressing');
    $('body').prepend('<img src="/loading_img/loading.gif" alt="Loading Image" id="loading_img">')
  })

  // プロフィール画像を未登録の状態でランチカードをクリックしたとき
  $('.ban_entry').on('click',function(){
    alert('プロフィール写真を登録しないとエントリーできません。')
    return false
  })

  // Infinite Scroll
  $(".timeline-shows").infinitescroll({
    loading: {
      img: "/loading_img/loading.gif",
      msgText: "loading..."
    },
    navSelector: "nav.pagination",
    nextSelector: "nav.pagination a[rel=next]",
    itemSelector: ".timeline-shows div.tweet"
  })

  // selectのラベルを更新
  $('select#tweet_category_id').on('change', function(){
    var $this = $(this)
    var $option = $this.find('option:selected')
    $('.select_label').text($option.text())
    $this.blur();
  })

})