$(document).ready(function (){
    $(document).on('keydown', '#tweet_content', function(e){
        if(e.metaKey && e.keyCode === 13){
            if((content = $('#tweet_content').val()) != ''){
                $.ajax({
                  type: 'POST',
                  url: '/tweets/create',
                  data:{
                    'tweet': {
                        'content': content,
                        'category_id': $('[name="tweet[category_id]"').val(),
                    }
                  }
                }).done(function(data) {
                }).fail(function(data) {
                })
            }
        }
    })
})