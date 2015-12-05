class ChangeCOlumnNameOfField < ActiveRecord::Migration
  def change
  	rename_column :fields, :column, :column_name
  end
end
