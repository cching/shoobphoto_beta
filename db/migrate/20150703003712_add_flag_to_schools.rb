class AddFlagToSchools < ActiveRecord::Migration
  def up
  	add_column :schools, :default, :boolean, default: false
  end
end
