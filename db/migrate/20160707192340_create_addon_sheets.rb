class CreateAddonSheets < ActiveRecord::Migration
  def change
    create_table :addon_sheets do |t|
      t.integer :addon_id
      t.integer :order_package_id
      t.integer :index
      t.integer :senior_image_id

      t.timestamps
    end
  end
end
