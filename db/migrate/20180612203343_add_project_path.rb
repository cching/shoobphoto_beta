class AddProjectPath < ActiveRecord::Migration
  def change
  	add_column :dprojects, :project_path, :text
  	change_column :dprojects, :tracking_number, :string
  end
end
