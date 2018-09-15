class AddSec1UpdToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :sec1_upd, :datetime
  end
end
