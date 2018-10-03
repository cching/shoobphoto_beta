class AddPrinFnameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :prin_fname, :string
  end
end
