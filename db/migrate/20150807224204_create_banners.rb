class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.integer :school_id

      t.timestamps
    end
  end
end
