$(document).ready(function (){

  'use strict';

  // 第一層のカテゴリーを選択した時に、その下層のカテゴリーを表示する
  var $firsts = $('.first_categories [data-first]'),
    $first_parents = $('.second_categories [data-first-id]');
  $firsts.on('click', function(e) {
    e.preventDefault();
    var $this = $(this);
    
    $firsts.removeClass('active');
    $this.addClass('active');

    var $firstChild = $this.attr('data-first');

    if ($firstChild == 'all') {
      $first_parents.removeClass('is-animated')
        .fadeOut().promise().done(function() {
          $first_parents.addClass('is-animated').fadeIn();
        });
    } else {
      $first_parents.removeClass('is-animated')
        .fadeOut().promise().done(function() {
          $first_parents.filter('[data-first-id = "' + $firstChild + '"]')
            .addClass('is-animated').fadeIn();
        });
    }
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

    var $secondChild = $this.attr('data-second');

    $second_parents.removeClass('is-animated')
      .fadeOut().promise().done(function() {
        $second_parents.filter('[data-second-id = "' + $secondChild + '"]')
          .addClass('is-animated').fadeIn();
      })
  })
  // 
  

})