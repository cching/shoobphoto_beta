class CreateFonts < ActiveRecord::Migration
  def change
    create_table :fonts do |t|
      t.string :name
      t.string :file_file_name
      t.string :file_content_type
      t.string :file_file_size
      t.string :file_updated_at

      t.timestamps
    end
  end
end
