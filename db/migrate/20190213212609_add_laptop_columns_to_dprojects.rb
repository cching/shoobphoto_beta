class AddLaptopColumnsToDprojects < ActiveRecord::Migration
  def change
    add_column :djobs, :LAPTOP_NOTES, :text
    add_column :djobs, :LAPTOP_DLD, :text
  end
end
