class CreateWarehouses < ActiveRecord::Migration[5.0]
  def change
    create_table :warehouses do |t|
      t.string :name
      t.string :location
      t.timestamps null: false
    end
    end
end
