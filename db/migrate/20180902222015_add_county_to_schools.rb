class AddCountyToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :county, :string
  end
end
