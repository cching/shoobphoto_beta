class AddSchoolToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :school, :string
  end
end
