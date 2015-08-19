class AddColumnToSchools < ActiveRecord::Migration
  def up
  	add_column :students, :school_id, :integer
  end
end
