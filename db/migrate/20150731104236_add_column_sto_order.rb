class AddColumnStoOrder < ActiveRecord::Migration
  def up
  	add_column :orders, :school_id, :integer
  	add_column :orders, :student_id, :integer
  end
end
