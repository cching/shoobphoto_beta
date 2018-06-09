class AddShippingColumnsToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :delivery_method, :string
  	add_column :dprojects, :route, :string
  	add_column :dprojects, :delivery_date, :datetime
  	add_column :dprojects, :tracking_number, :integer
  	add_column :dprojects, :shipping_instructions, :string
  	add_column :dprojects, :invoicing, :boolean
  end
end
