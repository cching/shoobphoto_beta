class AddRouteToSchools < ActiveRecord::Migration
  def change
  	add_column :schools, :route, :string
  end
end
