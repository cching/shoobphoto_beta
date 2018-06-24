class AddAssignedByToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :assigned_by, :string
  end
end
