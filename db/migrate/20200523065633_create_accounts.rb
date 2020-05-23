class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :phone
      t.string :type
      t.string :sf_id
      t.string :owner_id
      t.string :parent_id
      t.boolean :is_deleted, default: false
      
      t.timestamps
    end
  end
end
