class ChangeTimestampsInUser < ActiveRecord::Migration[5.1]
  def change
    create_table :foos do |t|
      t.string :name
      t.timestamp null: false
    end
  end
end
