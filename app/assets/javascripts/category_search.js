$(document).on('turbolinks:load', function(){
    var keyupStack = []
    $(document).on('keyup', '#search_form', function(e){
        keyupStack.push(1)
        
        //入力後0.3秒後
        setTimeout(function() {
            // 配列の後ろに追加
            //配列の中身排出
            keyupStack.pop()
            //取り出したstackの中身がなければ処理をする
            //stackの中身がなくなるのは、一番最後の入力から0.3秒後になる
            //なので、一番最後の入力から0.3秒後に以下の処理が走る
            
            if (keyupStack.length == 0) {
                //最後キー入力後に処理したいイベント
                e.preventDefault(); //キャンセル可能なイベントをキャンセル
                var input = $.trim($(this).val())
                $.ajax( {
                    url: '/categories/search',
                    type: 'GET',
                    data: ('keyword=' + input),
                    contentType: false,
                    dataType: 'json'
                }).done(function(data){ //データを受け取ることに成功したら、dataを引数に取って以下のことする(dataには@usersが入っている状態ですね)
                    $('#search_result').find('li').remove();  //idがresultの子要素のliを削除する
                    $(data).each(function(i, category){ //dataをuserという変数に代入して、以下のことを繰り返し行う(単純なeach文ですね)
                    $('#search_result').append('<li>' + category.name + '</li>') //resultというidの要素に対して、<li>ユーザーの名前</li>を追加する。
                    })
                }).fail(function(data) {
                })

            }
        }.bind(this), 350)

    })
})