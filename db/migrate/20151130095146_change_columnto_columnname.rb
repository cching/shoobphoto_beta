class ChangeColumntoColumnname < ActiveRecord::Migration
  def change
  	rename_column :fields, :column_name, :column
  end
end
