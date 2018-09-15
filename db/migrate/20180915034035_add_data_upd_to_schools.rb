class AddDataUpdToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :data_upd, :datetime
  end
end
