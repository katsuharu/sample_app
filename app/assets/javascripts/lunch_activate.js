$(document).on('turbolinks:load', function(){ 
    var states = $('.lunch_state')
    var len = states.length

    for(var i = 0; i < len; i++) {
        if (states.eq(0).text() == 'このカテゴリーで今日のランチを開催しますか？') {  //非activeな状態のとき
            $('.lunch_card').addClass('lunch_inactive')
        } else {
            $('.lunch_card').addClass('lunch_activated')
        }
    }

})