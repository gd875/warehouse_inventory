class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :address
      t.string :contact_person
      t.string :email
      t.string :phone_number
      t.integer :user_id
      t.timestamps null: false
    end
end
end
