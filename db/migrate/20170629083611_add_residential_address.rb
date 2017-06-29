class AddResidentialAddress < ActiveRecord::Migration
  def change
  	add_column :corders, :residential, :boolean
  end
end
 