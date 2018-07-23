class AddStatusDateToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :status_date, :datetime
  end
end
