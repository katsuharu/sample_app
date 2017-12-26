class RecreateUsers < ActiveRecord::Migration[5.0]
  def change
  	create_table :users do |t|
  	  t.string :name
  	  t.string :email
  	  t.string :department_name
  	  t.string :slack_id
  	  t.integer :category_id
  	  t.integer :pair_id
  	  t.string   :password_digest
  	  t.string   :remember_digest
  	  t.string   :activation_digest
  	  t.boolean  :activated
  	  t.datetime :activated_at
  	  t.string   :reset_digest
  	  t.datetime :reset_sent_at
  	  t.string   :profile_img
  	  t.integer  :position_id
  	  t.string   :self_intro
  	  t.integer  :any_category

  	  t.timestamps
  	end
  end
end