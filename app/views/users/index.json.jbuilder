if @new_tweets.present? # @new_tweetsに中身があれば
  json.array! @new_tweets # 配列かつjson形式で@new_tweetsを返す
end