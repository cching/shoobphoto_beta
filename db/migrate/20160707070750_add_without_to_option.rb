class AddWithoutToOption < ActiveRecord::Migration
  def change
  	add_column :options, :without, :boolean, default: false
  end
end
