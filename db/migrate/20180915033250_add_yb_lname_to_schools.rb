class AddYbLnameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :yb_lname, :string
  end
end
