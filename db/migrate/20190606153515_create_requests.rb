class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.string :email
      t.string :description
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
