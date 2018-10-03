class AddPrinLnameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :prin_lname, :string
  end
end
