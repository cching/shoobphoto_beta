class AddBoxesToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :boxes, :integer
  end
end
