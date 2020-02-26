class CreateReceipts < ActiveRecord::Migration[5.1]
  def change
    create_table :receipts do |t|
      t.references :money_transaction
      t.text :receipt_data

      t.timestamps
    end

    add_foreign_key :receipts, :transactions, column: :money_transaction_id
  end
end
