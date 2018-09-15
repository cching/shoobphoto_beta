class AddPicDateToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :pic_date, :datetime
  end
end
