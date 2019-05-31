class AddAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.belongs_to :user
      t.string :name
      t.float :balance
      t.string :note
      t.string :currency
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
