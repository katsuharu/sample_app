class DailyLunchesController < ApplicationController
  before_action :admin_user

  def index
    # 一覧を取得
    @daily_lunches = DailyLunch.where(deleted_at: nil).order('date')
  end

  def create
    csv_file = params[:daily_lunches][:csv_file]
    if csv_file.present?
      begin
        # 文字コードをUTF-8に変換してCSVファイルを読み込む
        csv_datas = FileModule.readCsvFile(csv_file)
        ActiveRecord::Base.transaction do
          # daily_lunchesレコードを作成
          FileModule.dailyLunchCreate(csv_datas)
          # 管理画面にリダイレクト
          redirect_to daily_lunches_index_path
        end
      rescue DailyLunchCreateError => e
        # エラーログの出力
        logger.error ErrorTexts::DAILY_LUNCHES[:create]
        logger.error e
        # 登録に失敗した場合は管理画面に戻ってエラーメッセージを表示
        redirect_to daily_lunches_index_path, alert: e
      rescue => e
        # エラーログの出力
        logger.error ErrorTexts::DAILY_LUNCHES[:create]
        logger.error e
        # 管理画面へリダイレクト
        redirect_to daily_lunches_index_path, alert: "デイリーランチ登録エラー" + e.message
      end
    else
     # 管理画面にリダイレクト
     redirect_to daily_lunches_index_path
    end
  end

  def update
    csv_file = params[:daily_lunches][:csv_file]
    if csv_file.present?
      begin
        # 文字コードをUTF-8に変換してCSVファイルを読み込む
        csv_datas = FileModule.readCsvFile(csv_file)
        ActiveRecord::Base.transaction do
          # DailyLunchを取得
          daily_lunches = DailyLunch.get_plans
          # 論理削除
          daily_lunches.update_all(deleted_at: DateTime.now)
          # 新しくアップしたCSVファイルをもとにdaily_lunchesを作成
          FileModule.dailyLunchCreate(csv_datas)
          # 管理画面にリダイレクト
          redirect_to daily_lunches_index_path
        end
      rescue DailyLunchCreateError => e
        # エラーログの出力
        logger.error ErrorTexts::DAILY_LUNCHES[:update]
        logger.error e
        # 登録に失敗した場合は管理画面に戻ってエラーメッセージを表示
        redirect_to daily_lunches_index_path, alert: e
      rescue => e
        # エラーログの出力
        logger.error ErrorTexts::DAILY_LUNCHES[:update]
        logger.error e
        # 管理画面へリダイレクト
        redirect_to daily_lunches_index_path, alert: "デイリーランチ更新エラー" + e.message
      end
    else
      # 管理画面にリダイレクト
      redirect_to daily_lunches_index_path
    end
  end

  private
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.present? && current_user.admin?
    end

end