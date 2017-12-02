$(document).on('turbolinks:load', function() {
  
  var photo_list$ = $('#photo_list');
  var li$ = $('#photo_list li');
  var li_count = li$.length;
  var li_width = li$.width() + parseInt(li$.css('margin-left'), 10) + parseInt(li$.css('margin-right'), 10);
  var ul_padding = parseInt(photo_list$.css('padding-left') , 10) + parseInt(photo_list$.css('padding-right') , 10);
  var slider_inner$ = $('#slider_inner');
  //#slider_inner の幅は「 li 要素の幅（マージンを含む） X その個数」と ul 要素のパディングの合計
  slider_inner$.css('width', (li_width * li_count + ul_padding) + 'px');
  //最後の画像（#photo_list li:last）を ul 要素の先頭位置に移動（prependTo）
  $('#photo_list li:last').prependTo(photo_list$);
  //slider_inner を上記で移動した分だけ左方向へずらす
  slider_inner$.css('margin-left', '-' + li_width + 'px');  
  
  var slide = function(){
    slider_inner$.stop().animate({
      marginLeft: parseInt(slider_inner$.css('margin-left'), 10) - li_width + 'px'
    }, 800,
    function(){
      slider_inner$.css('margin-left', '-' + li_width + 'px');
      $('#photo_list li:first').appendTo(photo_list$);
    });
  };
  
  var timer;
  function start_carousel() {
    timer = setInterval(slide ,1500);
  } 
  
  //自動的にスタートするように設定
  start_carousel();

});