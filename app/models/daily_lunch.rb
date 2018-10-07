class DailyLunch < ApplicationRecord
  # 12:30以前の場合は本日の日付の、以降の場合は明日の日付のDailyLunchを取得する関数
  def self.get_card
    # 12:30以前の場合
    if DateTime.now.strftime('%H:%M:%S') < "12:30:00"
      # dateカラムの値が本日のレコードを取得
      daily_lunches = DailyLunch.where(date: Date.today).where(deleted_at: nil)
    else
      # 明日の日付のレコードを取得
      daily_lunches = DailyLunch.where(date: Date.tomorrow).where(deleted_at: nil)
    end
  end

  # 12:30以前の場合は本日以降の、12:30以降の場合は明日以降の日付のDailyLunchを取得する関数
  def self.get_plans
    # 12:30以前の場合
    if DateTime.now.strftime('%H:%M:%S') < "12:30:00"
      # dateカラムの値が本日以降のレコードを取得
      daily_lunches = DailyLunch.where("date >= ?", Date.today).where(deleted_at: nil)
    else
      # dateカラムの値が明日以降のレコードを取得
      daily_lunches = DailyLunch.where("date > ?", Date.today).where(deleted_at: nil)
    end
  end
end