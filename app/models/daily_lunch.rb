class DailyLunch < ApplicationRecord
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