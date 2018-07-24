class AddDeliveredByToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :delivered_by, :string
  end
end
