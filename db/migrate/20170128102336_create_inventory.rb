class CreateInventory < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.string :name
      t.integer :product_id
      t.integer :warehouse_id
      t.integer :pallet_count
      t.integer :case_count
      t.integer :each_count
      t.integer :user_id
      t.timestamps null: false
    end
end
end
