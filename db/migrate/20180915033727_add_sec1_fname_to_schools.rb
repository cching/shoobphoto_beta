class AddSec1FnameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :sec1_fname, :string
  end
end
