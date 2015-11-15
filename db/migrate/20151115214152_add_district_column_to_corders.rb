class AddDistrictColumnToCorders < ActiveRecord::Migration
  def up
  	add_column :corders, :district, :string
  end
end
