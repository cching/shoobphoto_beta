class AddScodeToSchool < ActiveRecord::Migration
  def change
  	add_column :schools, :scode, :integer
  end
end
