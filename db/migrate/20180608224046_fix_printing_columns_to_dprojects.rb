class FixPrintingColumnsToDprojects < ActiveRecord::Migration
  def change
  	change_column :dprojects, :printing_instructions, :text
  end
end
