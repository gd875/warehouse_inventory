class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :each_in_case
      t.integer :cases_in_layer
      t.integer :layers_in_pallet
      t.timestamps null: false
    end
end
end
