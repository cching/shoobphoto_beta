class AddRecievedByToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :recieved_by, :string
  end
end
