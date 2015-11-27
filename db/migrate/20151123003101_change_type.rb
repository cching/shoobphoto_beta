class ChangeType < ActiveRecord::Migration
  def change
  	rename_column :columns, :type, :column_type
  end
end
