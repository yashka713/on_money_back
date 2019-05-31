class ChangeTransactions < ActiveRecord::Migration[5.1]
  def change
    rename_column :transactions, :amount, :from_amount
    add_column :transactions, :to_amount, :float
  end
end
