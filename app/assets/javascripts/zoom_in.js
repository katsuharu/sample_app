$(document).on('turbolinks:load', function() {
  'use strict'
  var ALREADY = false

  // 検索窓で表示したカテゴリーをクリックして趣味候補欄に追加
  $(document).on("click", 'ul#search_result.category_search li', function(){
    var clicked_category = $(this).text()
    $('.my_hobbies input').each(function() {
      if($(this).val() == clicked_category) {
        ALREADY = true
        return false
      }
    })

    if(!ALREADY) {
      $('#hobby_delete').append('<label for="user_hobby[hobby_name][]">削除</label>')
      $('#my_hobby').append('<input type="text" name="user_hobby[hobby_name][]" value="' + clicked_category + '" readonly>')
    }
    ALREADY = false
  })

  /* 第1層のカテゴリーを選択した時に、その下層のカテゴリーを表示する */
  // クリックした第1層のカテゴリのdata-first属性の値を取得する
  var $firsts = $('.first_categories [data-first]')
  // 第一層のカテゴリーを選択した時に、その下層のカテゴリーを表示する
  var $first_parents = $('.second_categories [data-first-id]')
  $firsts.on('click', function(e) {
    e.preventDefault()
    var $this = $(this)
    // 以前クリックされたカテゴリのactiveクラスを削除
    $firsts.removeClass('active')
    // 今回クリックしたカテゴリにactiveクラスを追加
    $this.addClass('active')
    // クリックした第一階層のカテゴリを取得
    var $firstChild = $this.attr('data-first')
    // クリックしたカテゴリーの子のカテゴリーをフェードイン
    $first_parents.removeClass('is-animated')
      .fadeOut().promise().done(function() {
        $first_parents.filter('[data-first-id = "' + $firstChild + '"]')
          .addClass('is-animated').fadeIn();
      })
    // 第3,第4カテゴリーを非表示に
    hide_lower_layers('first')
  })
  //

  /* 第2層のカテゴリーを選択した時に、その下層のカテゴリーを表示する */
  var $seconds = $('.second_categories [data-second]'),
  $second_parents = $('.third_categories [data-second-id]')
  $seconds.on('click', function(e) {
    e.preventDefault()
    var $this = $(this)
    $seconds.removeClass('active');
    $this.addClass('active');
    var $secondChild = $this.attr('data-second')
    $second_parents.removeClass('is-animated')
      .fadeOut().promise().done(function() {
        if($second_parents.filter('[data-second-id = "' + $secondChild + '"]').length) {
          $second_parents.filter('[data-second-id = "' + $secondChild + '"]')
            .addClass('is-animated').fadeIn()
        }else {   //「Add Hobby」に表示して、趣味登録の候補に追加する
          $('.my_hobbies input').each(function() {
            if($(this).val() == $this.text()) {
              ALREADY = true
              return false
            }
          })
          if(!ALREADY) {
            $('#hobby_delete').append('<label for="user_hobby[hobby_name][]">削除</label>')
            $('#my_hobby').append('<input type="text" name="user_hobby[hobby_name][]" value="' + $this.text()+ '" readonly>')
          }
          ALREADY = false
        }
      })
    // 第4カテゴリーを非表示に
    hide_lower_layers('second')
  })
  //

  /* 第3層のカテゴリーを選択した時に、その下層のカテゴリーを表示する */
  var $thirds = $('.third_categories [data-third]'),
    $third_parents = $('.forth_categories [data-third-id]')
  $thirds.on('click', function(e) {
    e.preventDefault()
    var $this = $(this)
    $thirds.removeClass('active')
    $this.addClass('active')

    var $thirdChild = $this.attr('data-third')

    $third_parents.removeClass('is-animated')
      .fadeOut().promise().done(function() {
        if($third_parents.filter('[data-third-id = "' + $thirdChild + '"]').length) {
          $third_parents.filter('[data-third-id = "' + $thirdChild + '"]')
            .addClass('is-animated').fadeIn()
        }else {
          $('.my_hobbies input').each(function() {
            if($(this).val() == $this.text()) {
              ALREADY = true
              return false
            }
          })
          if(!ALREADY) {
            $('#hobby_delete').append('<label for="user_hobby[hobby_name][]">削除</label>')
            $('#my_hobby').append('<input type="text" name="user_hobby[hobby_name][]" value="' + $this.text()+ '" readonly>')
          }
          ALREADY = false
        }
      })
  })
  //

  /* 第4層のカテゴリーを選択した時、候補に追加 */
  var $forths = $('.forth_categories [data-forth]')
  $forths.on('click', function(e) {
    e.preventDefault()
    var $this = $(this)
    $('.my_hobbies input').each(function() {
      if($(this).val() == $this.text()) {
        ALREADY = true
        return false
      }
    })
    if(!ALREADY) {
      $('#hobby_delete').append('<label for="user_hobby[hobby_name][]">削除</label>')
      $('#my_hobby').append('<input type="text" name="user_hobby[hobby_name][]" value="' + $this.text()+ '" readonly>')
    }
    ALREADY = false
  })

  // params layer: String
  // 引数のカテゴリーの2下層下のカテゴリー以降を非表示にする
  function hide_lower_layers(layer) {
    switch(layer){
      // 第1階層のカテゴリーがクリックされたとき
      case 'first' :
        // 第3,第4層のカテゴリを非表示に
        $('.third_category').hide()
        $('.forth_category').hide()
        break
      // 第2階層のカテゴリーがクリックされたとき
      case 'second' :
        // 第4層のカテゴリを非表示に
        $('.forth_category').hide()
        break
    }
  }
  //趣味登録ページで、my hobbyから趣味を削除するかどうかをcheckboxの値で判断
  $(document).on('click', '#hobby_delete label', function() {
    var index = $('#hobby_delete label').index(this)
    // カテゴリーlabeを削除
    $('#my_hobby input:eq(' + index+ ')').remove();
    // 削除ラベルを削除
    $('#hobby_delete label:eq(' + index+ ')').remove();    
  })
  // 趣味登録ボタン押下時
  $(document).on('click', '#hobby_register', function() {
    // 趣味が一つも選択されていない場合
    if ($("input[name='user_hobby[hobby_name][]']").val() == undefined) {
        // アラートを出力
        alert('趣味を一つ以上選択してください')
        // submit処理を中止
        return false
      }
  })

  //趣味編集ページで、my hobbyから趣味を削除するかどうかをcheckboxの値で判断
  $(document).on('click', '#my_hobby_del', function() {
    if($('input:checkbox[name="user_hobbies[id][]"]:checked').length) {
    }else {
      alert('一つ以上チェックしてください')
      return false
    }
  })
})