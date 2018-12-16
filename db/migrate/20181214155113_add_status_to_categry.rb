class AddStatusToCategry < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :status, :integer, null: false, default: 0
  end
end
