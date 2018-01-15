/* global $ */
$(document).on('turbolinks:load', function() {
  // food_list
  var meat_list= ['すき焼き', 'ハンバーグ', '生姜焼き', 'とんかつ']
  var fish_list = ['サバの味噌煮', '刺身', '秋刀魚の塩焼き', 'しらす丼']
  var vege_list = ['玉ねぎ', '人参', 'レタス']

  // movie_list
  var comedy_list = ['ホーム・アローン', 'King Of Comedy']
  var anime_list = ['ドラえもん', 'ポケモン', 'ワンピース']

  // music_list
  var jpop_list = ['いきものがかり', 'コブクロ', 'ゆず']
  var rock_list = ['The Beatles', 'Oasis', 'The Beach Boys', 'Eric Clapton']
 

  // hobby_list
  var food_list = { 'お肉': meat_list, 'お魚': fish_list, 'お野菜': vege_list }
  var movie_list = {'コメディ': comedy_list , 'アニメ': anime_list}
  var music_list = {'JPOP': jpop_list , 'ロック':rock_list}

  //
  var foods = [meat_list, fish_list, vege_list]

  var hobby_list = {'foods': food_list, 'movies': movie_list, 'musics': music_list}
  var food_list = { meats: meat_list, fishs: fish_list, veges: vege_list }

  var kind_layer = document.getElementById('kind_layer')
  var con_list = document.getElementById('con_list')


  // １階層目のitemをクリックした時に、下層のitemリストを表示
  $('#hobby_layer li').click(function() {
    var id = $(this).attr('id')

    // console.log(hobby_list[id])
    var keyset = Object.keys(hobby_list[id])
    // console.log(keyset)

    var len = keyset.length
    // console.log(len)

    if (kind_layer.getElementsByTagName('li').length > 0) {
      // 全てのliを削除
      while (kind_layer.firstChild) {
        kind_layer.removeChild(kind_layer.firstChild)
      }
      $(kind_layer).removeClass()
      $(kind_layer).addClass(id)   
      for (var i = 0; i < len; i++) {
        var li = document.createElement('li')
        var text = document.createTextNode(keyset[i])
        li.appendChild(text)
        kind_layer.appendChild(li)
      }
    } else {
      $(kind_layer).removeClass()
      $(kind_layer).addClass(id)
      for (var i = 0; i < len; i++) {
        var li = document.createElement('li')
        var text = document.createTextNode(keyset[i])
        li.appendChild(text)
        kind_layer.appendChild(li)
      }
    }
  })


  // 二階層目のitemをクリックした時に、下層のitemリストを表示
  $(document).on('click', '#kind_layer li', function() {
    var cls = $(this).parent().attr('class')
    // console.log($(this).parent())


    var target = $(this)
    var len = hobby_list[cls][target.text()].length

    // console.log(target.text())

    // console.log(hobby_list[cls])
    console.log(hobby_list[cls][target.text()])


    if (con_list.getElementsByTagName('li').length > 0) {
      // 全てのliを削除
      while (con_list.firstChild) {
        con_list.removeChild(con_list.firstChild)
      }
      $(con_list).removeClass()
      $(con_list).addClass(cls)
      for (var i = 0; i < len; i++) {
        var li = document.createElement('li')
        var text = document.createTextNode(hobby_list[cls][target.text()][i])
        li.append(text)
        con_list.appendChild(li)
      }
    } else {
      $(con_list).removeClass()
      $(con_list).addClass(cls)
      for (var i = 0; i < len; i++) {
        var li = document.createElement('li')
        var text = document.createTextNode(hobby_list[cls][target.text()][i])
        li.append(text)
        con_list.appendChild(li)

        $('#my_hobby li').each(function() {
          if ($(this).text() === text) {
            li.addClass('already')
          }
        })

      }
    }



  })



  $(document).on('click', '#con_list li', function() {
    var target = $(this).text()
    var isSame = false
    $('#my_hobby li').each(function() {
      if ($(this).text() === target) {
        isSame = true
      }
    })

    if (isSame) {
      console.log('already exists')
    } else {
      var li = document.createElement('li')
      var li_del = document.createElement('li')
      li_del.append('削除')
      li.append(target)
      $('#my_hobby').append(li)
      $('#hobby_delete').append(li_del)
    }
  })

  $(document).on('click', '#hobby_delete li', function() {
    var index = $('#hobby_delete li').index(this)
    console.log("立川談志")
    console.log(index)

    $('#my_hobby li:eq(' + index+ ')').remove();
    $('#hobby_delete li:eq(' + index+ ')').remove();    
  })

})