class ChangeDefaultColumnType < ActiveRecord::Migration
  def change
  	change_column_default(:corders, :processed, false)

  end
end
