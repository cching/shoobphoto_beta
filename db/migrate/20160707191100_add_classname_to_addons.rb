class AddClassnameToAddons < ActiveRecord::Migration
  def change
  	add_column :addons, :css_name, :string
  end
end
