class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.integer :type_of, null: false
      t.string :name, limit: 25
      t.string :note, limit: 100
      t.belongs_to :user
    end
  end
end
