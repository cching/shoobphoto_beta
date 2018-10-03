class AddAwdLnameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :awd_lname, :string
  end
end
