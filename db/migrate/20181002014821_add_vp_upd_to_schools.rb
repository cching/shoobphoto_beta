class AddVpUpdToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :vp_upd, :datetime
  end
end
