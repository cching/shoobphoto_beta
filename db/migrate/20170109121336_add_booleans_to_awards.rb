class AddBooleansToAwards < ActiveRecord::Migration
  def change
  	add_column :awards, :add_awarded_for, :boolean, default: false
  	add_column :awards, :add_definition, :boolean, default: false
  end
end
