class AddFileDescriptionToDprojects < ActiveRecord::Migration
  def change
    add_column :dprojects, :file_description, :string
  end
end
