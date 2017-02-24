class RenameAccessCode < ActiveRecord::Migration
  def change
  	rename_column :student_images, :access_code, :accesscode
  end
end
