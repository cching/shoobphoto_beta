class AddFinishToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :finish, :boolean
  end
end
