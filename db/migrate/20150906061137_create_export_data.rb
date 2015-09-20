class CreateExportData < ActiveRecord::Migration
  def change
    create_table :export_data do |t|
      t.text :kind
      t.integer :type_id
      t.string :prompt_values
      t.string :sort_by
      t.string :certificate_title
      t.string :distribution_date
      t.string :additional_information
      t.integer :user_id
      t.string :file_file_name
      t.string :file_content_type
      t.string :file_file_size
      t.string :file_updated_at

      t.timestamps
    end
  end
end
