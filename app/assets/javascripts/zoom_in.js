$(document).ready(function (){

  'use strict'

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
    e.preventDefault();
    var $this = $(this);
    
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
          $('#my_hobby').append('<input type="text" value="' + $this.text()+ '" readonly>')

          console.log(false)
        }
      })
  })
  //

  // 第三層のカテゴリーを選択した時に、その下層のカテゴリーを表示する
  var $thirds = $('.third_categories [data-third]'),
    $third_parents = $('.forth_categories [data-third-id]')
  $thirds.on('click', function(e) {
    e.preventDefault();
    var $this = $(this);
    
    $thirds.removeClass('active');
    $this.addClass('active');

    var $thirdChild = $this.attr('data-third')

    $third_parents.removeClass('is-animated')
      .fadeOut().promise().done(function() {
        if($third_parents.filter('[data-third-id = "' + $thirdChild + '"]').length) {
          $third_parents.filter('[data-third-id = "' + $thirdChild + '"]')
            .addClass('is-animated').fadeIn()
          console.log(true)
        }else {
          $('#my_hobby').append('<input type="text" value="' + $this.text() + '" readonly>')
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
    $('#my_hobby').append('<input type="text" value="' + $(this).text() + '" readonly>')
  })
})