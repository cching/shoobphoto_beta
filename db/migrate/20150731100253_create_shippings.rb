class CreateShippings < ActiveRecord::Migration
  def change
  	remove_column :packages, :shipping

    create_table :shippings do |t|
      t.decimal :price
      t.integer :school_id
      t.integer :package_id

      t.timestamps
    end
  end
end
