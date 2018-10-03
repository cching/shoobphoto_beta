class AddVpEmailToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :vp_email, :string
  end
end
