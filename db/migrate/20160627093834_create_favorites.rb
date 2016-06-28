class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :order_package_id
      t.integer :package_id
      t.integer :senior_image_id

      t.timestamps
    end
  end
end
