class AddSchoolIDtoDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :school_id, :integer
  end
end
