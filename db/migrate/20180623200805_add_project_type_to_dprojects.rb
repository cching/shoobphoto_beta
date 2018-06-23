class AddProjectTypeToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :project_type, :string
  end
end
