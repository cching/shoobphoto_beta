class AddPrinUpdToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :prin_upd, :datetime
  end
end
