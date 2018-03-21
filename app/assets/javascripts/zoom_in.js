$(document).ready(function (){

  'use strict';

  // 第一層のカテゴリーを選択した時に、その下層のカテゴリーを表示する
  var $firsts = $('.first_categories [data-first]'),
    $seconds = $('.second_categories [data-first-id]');
  $firsts.on('click', function(e) {
    e.preventDefault();
    var $this = $(this);
    
    $firsts.removeClass('active');
    $this.addClass('active');

    var $firstChild = $this.attr('data-first');

    if ($firstChild == 'all') {
      $seconds.removeClass('is-animated')
        .fadeOut().promise().done(function() {
          $seconds.addClass('is-animated').fadeIn();
        });
    } else {
      $seconds.removeClass('is-animated')
        .fadeOut().promise().done(function() {
          $seconds.filter('[data-first-id = "' + $firstChild + '"]')
            .addClass('is-animated').fadeIn();
        });
    }
  })
  //

  

})