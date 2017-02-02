class CreateTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :transfers do |t|
      t.integer :product_id
      t.integer :warehouse_id
      t.integer :customer_id
      t.integer :quantity
      t.string :user_id
      t.timestamps null: false
    end
end
end
