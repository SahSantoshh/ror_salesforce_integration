class CreatePushTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :push_topics do |t|
      t.string :sf_id
      t.boolean :is_account
      
      t.timestamps
    end
  end
end
