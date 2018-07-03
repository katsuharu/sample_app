class AddSentAtToLunches < ActiveRecord::Migration[5.0]
  def change
    add_column :lunches, :sent_at, :datetime, comment: '送信日時'
  end
end