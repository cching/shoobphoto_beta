class AddYbUpdToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :yb_upd, :datetime
  end
end
