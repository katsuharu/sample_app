class AddIndexToAuthorizationsProviderUid < ActiveRecord::Migration[5.0]
  def change
  	add_index :authorizations, [:provider, :uid], unique: true
  end
end
