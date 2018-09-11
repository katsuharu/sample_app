var slide_ary = []

$(document).on('turbolinks:load', function() {
  $('.lunch_card').each(function(index) {
    var photo_list$ = $("#photo_list_" + index)
    var li$ = $('#photo_list_' + index + ' li')
    var li_count = li$.length
    // 6人以上エントリーしている場合にスライドさせる
    if(li_count >= 6) {
      var li_width = li$.width() + parseInt(li$.css('margin-left'), 10) + parseInt(li$.css('margin-right'), 10)
      var ul_padding = parseInt(photo_list$.css('padding-left') , 10) + parseInt(photo_list$.css('padding-right') , 10);
      var slider_inner$ = $('#slider_inner_' + index);
      //#slider_inner の幅は「 li 要素の幅（マージンを含む） X その個数」と ul 要素のパディングの合計
      slider_inner$.css('width', (li_width * li_count + ul_padding) + 'px')
      //最後の画像（#photo_list li:last）を ul 要素の先頭位置に移動（prependTo）
      $('#photo_list_' + index + ' li:last').prependTo(photo_list$)
      //slider_inner を上記で移動した分だけ左方向へずらす
      slider_inner$.css('margin-left', '-' + li_width + 'px')
      var slide = function(){
        slider_inner$.stop().animate({
          marginLeft: parseInt(slider_inner$.css('margin-left'), 10) - li_width + 'px'
        }, 800,
        function(){
          slider_inner$.css('margin-left', '-' + li_width + 'px')
          $('#photo_list_' + index + ' li:first').appendTo(photo_list$)
        })
      }
      slide_ary.push(slide)
    }
  })

  var timer
  function start_carousel(slide) {
    timer = setInterval(slide ,1500)
  }
    
  //自動的にスタートするように設定。スライドの枚数文動かす
  $('.lunch_card').each(function(index) {
    var li$ = $('#photo_list_' + index + ' li')
    var li_count = li$.length
    if(li_count > 4) {
      start_carousel(slide_ary[index])
    }
  })

    $(window).on('turbolinks:render', function() {
      window.clearInterval(timer)
    })
})