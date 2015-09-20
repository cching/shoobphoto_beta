class CreatePdfs < ActiveRecord::Migration
  def change
    create_table :pdfs do |t|
      t.string :name
      t.string :file_file_name
      t.string :file_file_size
      t.string :file_content_type
      t.string :file_updated_at
      t.string :template_id

      t.timestamps
    end
  end
end
