class AddNotesToOrder < ActiveRecord::Migration
  def up
  	add_column :orders, :notes, :text
  end
end
