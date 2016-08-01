class CreateZipcodes < ActiveRecord::Migration
  def change
    create_table :zipcodes do |t|
      t.integer :zip_code

      t.timestamps
    end

    add_column :carts, :zip_code, :integer
  end
end
