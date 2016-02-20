class AddColumnsToSchools < ActiveRecord::Migration
  def change
  	add_column :schools, :district_id, :integer
  	add_column :schools, :city_id, :integer
  	add_column :schools, :address, :string
  	add_column :schools, :phone, :string
  	add_column :schools, :principal, :string
  	add_column :schools, :secretary, :string
  	add_column :schools, :cdscode, :string
  	add_column :schools, :visible, :boolean, default: false
  	add_column :notes, :school_id, :integer
  end
end
