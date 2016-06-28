class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.integer :senior_image_id
      t.integer :order_package_id
      t.integer :image_type_id
      t.integer :index

      t.timestamps
    end
  end
end
