class CreateOrderPackages < ActiveRecord::Migration
  def change
    create_table :order_packages do |t|
      t.integer :package_id
      t.integer :order_id

      t.timestamps
    end
  end
end
