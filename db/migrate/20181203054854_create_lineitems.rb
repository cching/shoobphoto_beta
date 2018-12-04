class CreateLineitems < ActiveRecord::Migration
  def change
    create_table :lineitems do |t|
      t.integer :quantity
      t.integer :product_code
      t.string :product
      t.integer :price
      t.integer :extended_price
      t.timestamp :created_at
      t.timestamp :updated_at
      t.integer :invoice_id

      t.timestamps
    end
  end
end
