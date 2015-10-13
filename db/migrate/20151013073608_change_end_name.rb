class ChangeEndName < ActiveRecord::Migration
  def up
  	rename_column :prices, :end, :enddate
  end
end
