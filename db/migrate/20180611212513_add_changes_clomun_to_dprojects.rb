class AddChangesClomunToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :project_changes, :text
  	add_column :dprojects, :invoice_quantity, :integer
  	add_column :dprojects, :invoice_price, :integer
  end
end
