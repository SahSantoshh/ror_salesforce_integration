class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :title
      t.string :email
      t.string :phone
      t.string :mobile_phone
      t.boolean :is_deleted
      t.string :sf_id
      t.string :sf_account_id
      t.string :owner_id

      t.timestamps
    end
  end
end
