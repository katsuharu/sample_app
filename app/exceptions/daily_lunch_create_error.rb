class DailyLunchCreateError < StandardError
  # 読み取り専用のアクセサメソッドを定義
  attr_reader :csv_row

  # 初期化処理
  # param String message エラーメッセージ
  # param Integer csv_row CSVファイル行数
  def initialize(message, csv_row)
    @csv_row = csv_row
    super("#{message} #{csv_row}" )
  end
end