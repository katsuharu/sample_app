class AddCanceledAtToLunches < ActiveRecord::Migration[5.0]
  def change
    add_column :lunches, :canceled_at, :datetime
  end
end
