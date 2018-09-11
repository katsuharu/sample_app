module UsersHelper extend ActiveSupport::Concern
  def entried?
    # 12:30以前の場合
    if DateTime.now.strftime('%H:%M:%S') < "12:30:00"
      # 本日のランチにエントリ中の場合にtrueを返す
      Lunch.where(user_id: current_user.id).where(lunch_date: Date.today).where.not(category_id: nil).where(canceled_at: nil).present?
    # 12:30以降の場合
    else
      # 明日の日付のランチにエントリ中の場合にtrueを返す
      Lunch.where(user_id: current_user.id).where(lunch_date: Date.tomorrow).where.not(category_id: nil).where(canceled_at: nil).present?
    end
  end

  def matched?
    # ログインユーザーがマッチング済みの場合にtrueを返す
    Lunch.where.not(pair_id: nil).where(user_id: current_user.id).where(lunch_date: Date.today).present?
  end

  def data_uri_to_file data_uri
    # データURIスキームを正規表現で分割
    data = data_uri.try do |uri|
      uri.match(%r{\Adata:(?<type>.*?);(?<encoder>.*?),(?<data>.*)\z}) do |md|
        {
          type:      md[:type],
          encoder:   md[:encoder],
          data:      Base64.decode64(md[:data]),
          extension: md[:type].split('/')[1]
        }
      end
    end
    return nil unless data

    # 画像のTempfileを作成
    temp_file = Tempfile.new('uploaded-data_uri').tap do |file|
      file.binmode
      file << data[:data]
      file.rewind
    end


    # 画像fileを作成
    ActionDispatch::Http::UploadedFile.new(
      filename: "data_uri.#{data[:extension]}",
      type:     data[:type],
      tempfile: temp_file
    )
  end
end