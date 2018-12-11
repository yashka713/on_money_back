class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :chargeable, polymorphic: true, index: true
      t.references :profitable, polymorphic: true, index: true
      t.belongs_to :user
      t.integer :operation_type
      t.float :amount
      t.string :note

      t.datetime :date
    end
  end
end
