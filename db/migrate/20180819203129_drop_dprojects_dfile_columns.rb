class DropDprojectsDfileColumns < ActiveRecord::Migration
  def change
    remove_column :dprojects, :dfile_file_name
    remove_column :dprojects, :dfile_content_type
    remove_column :dprojects, :dfile_file_size
    remove_column :dprojects, :dfile_updated_at
  end
end
