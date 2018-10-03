class AddAwdUpdToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :awd_upd, :datetime
  end
end
