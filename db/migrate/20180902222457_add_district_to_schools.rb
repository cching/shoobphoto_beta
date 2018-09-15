class AddDistrictToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :district, :string
  end
end
