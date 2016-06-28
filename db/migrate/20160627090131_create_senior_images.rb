class CreateSeniorImages < ActiveRecord::Migration
  def change
    create_table :senior_images do |t|
      t.integer :student_image_id
      t.string :url
      t.integer :index

      t.timestamps
    end
  end
end
