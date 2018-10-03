class AddGreatschoolsToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :greatschools, :string
  end
end
