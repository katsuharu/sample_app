$(document).on 'turbolinks:load', () ->
  $('#entry_submit').on 'submit', ->
    flag = 0
    # 設定開始（チェックする項目を設定してください）
    if document.user[category_id].options[document.user[category_id].selectedIndex].value == ''
      flag = 1
    # 設定終了
    if flag
      window.alert '選択されていません'
      # 選択されていない場合は警告ダイアログを表示
      false
      # 送信を中止
    else
      true
      # 送信を実行