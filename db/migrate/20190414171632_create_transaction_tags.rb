class CreateTransactionTags < ActiveRecord::Migration[5.1]
  def change
    create_table :transaction_tags do |t|
      t.references :money_transaction
      t.references :tag, foreign_key: true

      t.timestamps
    end

    add_foreign_key :transaction_tags, :transactions, column: :money_transaction_id
  end
end
