class AddSchoolTypeIdToSchools < ActiveRecord::Migration
  def up
  	add_column :schools, :school_type_id, :integer
  end
end
