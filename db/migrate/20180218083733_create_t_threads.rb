class CreateTThreads < ActiveRecord::Migration[5.0]
  def change
    create_table :t_threads do |t|
      t.text :content
      t.integer :user_id
      t.integer :tweet_id

      t.timestamps
    end
  end
end
