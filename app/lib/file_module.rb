require 'nkf'
module FileModule

  def readCsvFile(csv_file)
    case NKF.guess(File.read(csv_file.tempfile)).to_s
    when 'Shift_JIS'
      csv_datas = CSV.read(csv_file.tempfile, encoding: "Shift_JIS:UTF-8")
    when 'UTF-16'
      csv_datas = CSV.read(csv_file.tempfile, encoding: "UTF-16:UTF-8")
    when 'UTF-8'
      # CSVファイルがスプレッドシートで作成された場合に改行に含まれる\rを削除する
      csv_datas = CSV.parse(csv_file.read.gsub /\r/, '')
    else
      raise DailyLunchCreateError.new("CSVファイル文字コードエラー" , "Shift_JIS、UTF-16、UTF-8以外の文字コードが利用されています")
    end
  end
  
  # アップロードしたCSVファイルのデータをもとにdaily_lunchesのレコードを作成するメソッド
  def dailyLunchCreate(csv_datas)
    # 処理中のcsvファイルの行数
    csv_row = 0
    csv_datas.each do |csv_data|
      # CSVの現在の処理している列数をカウント
      csv_row += 1
      # 日付列のフォーマットが正しい場合
      if csv_data[0].match(/\d{4}-\d{2}-\d{2}/)
        # CSVファイルのデータをもとにdaily_lunchesテーブルにデータをインサート
        daily_lunch = DailyLunch.new(name: csv_data[1], date: csv_data[0], category_id:csv_data[2])
        if !daily_lunch.save
          raise DailyLunchCreateError.new(daily_lunch.errors.full_messages.to_s + "、CSVファイルエラー該当行：" , csv_row)
        end
      end
    end
  end

  module_function :readCsvFile
  module_function :dailyLunchCreate
end