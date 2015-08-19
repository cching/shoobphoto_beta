class AddColumnToOption < ActiveRecord::Migration
  def up
  	add_column :options, :price, :integer
  end
end
