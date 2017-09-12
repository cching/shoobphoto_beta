class AddPrintSizeToProjectPrin < ActiveRecord::Migration
  def change
  	add_column :project_prints, :print_size_id, :integer
  	add_column :project_prints, :print_style_id, :integer
  end
end
