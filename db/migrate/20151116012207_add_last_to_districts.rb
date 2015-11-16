class AddLastToDistricts < ActiveRecord::Migration
  def up
  	add_column :districts, :last, :boolean, :default => false
  end
end
