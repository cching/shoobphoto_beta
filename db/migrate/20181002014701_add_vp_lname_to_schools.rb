class AddVpLnameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :vp_lname, :string
  end
end
