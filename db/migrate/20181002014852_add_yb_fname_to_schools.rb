class AddYbFnameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :yb_fname, :string
  end
end
