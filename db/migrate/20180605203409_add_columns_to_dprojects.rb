class AddColumnsToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :requested_by, :string
  	add_column :dprojects, :assigned_to, :string
  end
end
