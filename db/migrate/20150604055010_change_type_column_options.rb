class ChangeTypeColumnOptions < ActiveRecord::Migration
  def up
  	rename_column :options, :type, :package_type
  end
end
