$(document).ready(function (){
    $(document).on('keydown', '#t_thread_content', function(e){
        if(e.metaKey && e.keyCode === 13){
            if((content = $('#t_thread_content').val()) != ''){
                $.ajax({
                  type: 'POST',
                  url: '/tweets/thread_cmd_create',
                  data:{
                    't_thread': {
                        'content': content,
                        'tweet_id': $('#reply_tweet_id').html(),
                    }
                  }
                }).done(function(data) {
                    console.log('Done!!!')
                }).fail(function(data) {
                    console.log('Fail!!!')
                })
            } else {
                console.log('empty & Invalid')
            }
        }
    })
})