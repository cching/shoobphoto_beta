class CreateOptionCarts < ActiveRecord::Migration
  def change
    create_table :option_carts do |t|
      t.integer :order_package_id
      t.integer :option_id

      t.timestamps
    end
  end
end
