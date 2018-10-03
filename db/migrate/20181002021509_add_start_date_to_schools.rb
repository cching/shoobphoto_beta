class AddStartDateToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :start_date, :datetime
  end
end
