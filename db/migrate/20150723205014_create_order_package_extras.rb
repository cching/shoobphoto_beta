class CreateOrderPackageExtras < ActiveRecord::Migration
  def change
    create_table :order_package_extras do |t|
      t.integer :order_package_id
      t.integer :extra_id

      t.timestamps
    end
  end
end
