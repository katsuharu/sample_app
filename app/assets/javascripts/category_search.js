$(document).on('turbolinks:load', function(){ 
  $(document).on('keyup', '#search_form', function(e){ 
    e.preventDefault(); //キャンセル可能なイベントをキャンセル
    var input = $.trim($(this).val())

    $.ajax( {
    	url: '/categories/search',
    	type: 'GET',
    	data: ('keyword=' + input),
    	contentType: false,
    	dataType: 'json'
    })

    //ここから追記
	.done(function(data){ //データを受け取ることに成功したら、dataを引数に取って以下のことする(dataには@usersが入っている状態ですね)
		$('#search_result').find('li').remove();  //idがresultの子要素のliを削除する
	 	$(data).each(function(i, category){ //dataをuserという変数に代入して、以下のことを繰り返し行う(単純なeach文ですね)
	   	$('#search_result').append('<li>' + category.name + '</li>') //resultというidの要素に対して、<li>ユーザーの名前</li>を追加する。
		});
	})

  })
})