class AddSec1LnameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :sec1_lname, :string
  end
end
