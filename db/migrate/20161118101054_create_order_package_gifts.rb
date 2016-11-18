class CreateOrderPackageGifts < ActiveRecord::Migration
  def change
    create_table :order_package_gifts do |t|
      t.integer :order_package_id
      t.integer :gift_id

      t.timestamps
    end
  end
end
