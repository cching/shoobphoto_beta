class ChangeSchooltypeCOl < ActiveRecord::Migration
  def up
  	remove_column :banners, :school_id
  	add_column :banners, :school_type_id, :integer
  end
end
