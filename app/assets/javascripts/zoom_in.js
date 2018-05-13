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

  // 第一層のカテゴリーを選択した時に、その下層のカテゴリーを表示する
  var $firsts = $('.first_categories [data-first]'),
    $first_parents = $('.second_categories [data-first-id]')
  $firsts.on('click', function(e) {
    e.preventDefault()
    var $this = $(this)
    
    $firsts.removeClass('active')
    $this.addClass('active')

    var $firstChild = $this.attr('data-first')

    $first_parents.removeClass('is-animated')
      .fadeOut().promise().done(function() {
        $first_parents.filter('[data-first-id = "' + $firstChild + '"]')
          .addClass('is-animated').fadeIn();
      })
  })
  //

  // 第二層のカテゴリーを選択した時に、その下層のカテゴリーを表示する
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
          console.log(true)
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
          console.log(false)
        }
      })
  })
  //

  // 第三層のカテゴリーを選択した時に、その下層のカテゴリーを表示する
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
          console.log(true)
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
          console.log(false)
        }
      })
  })
  //

  // 第四層のカテゴリーを選択した時、候補に追加
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

  $(document).on('click', '#hobby_delete label', function() {
    var index = $('#hobby_delete label').index(this)

    $('#my_hobby input:eq(' + index+ ')').remove();
    $('#hobby_delete label:eq(' + index+ ')').remove();    
  })

  $(document).on('click', '#hobby_register', function() {
    if ($("input[name='user_hobby[hobby_name][]']").val() == undefined) {
        alert('趣味を一つ以上選択してください')
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