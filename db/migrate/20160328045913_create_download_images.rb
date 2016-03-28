class CreateDownloadImages < ActiveRecord::Migration
  def change
    create_table :download_images do |t|
      t.integer :package_id
      t.integer :student_id
      t.string :folder
      t.string :url
      t.string :shoob_id

      t.timestamps
    end
  end
end
