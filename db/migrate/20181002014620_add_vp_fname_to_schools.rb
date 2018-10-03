class AddVpFnameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :vp_fname, :string
  end
end
