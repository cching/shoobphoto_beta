class AddDataLnameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :data_lname, :string
  end
end
