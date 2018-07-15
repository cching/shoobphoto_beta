class CreateLineitems < ActiveRecord::Migration
  def change
    create_table :lineitems do |t|
      t.integer :dproject_id
      t.integer :quantity
      t.integer :product_code
      t.string :product
      t.decimal :price
      t.decimal :extended_price

      t.timestamps
    end
  end
end
