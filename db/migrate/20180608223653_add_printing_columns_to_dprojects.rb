class AddPrintingColumnsToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :delivered, :boolean
  	add_column :dprojects, :printing_instructions, :string
  end
end
