class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false, limit: 25
      t.belongs_to :user
    end
  end
end
