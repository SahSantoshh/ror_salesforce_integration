class AddAccountToContact < ActiveRecord::Migration[6.0]
  def change
    add_reference :contacts, :account, foreign_key: true
  end
end
