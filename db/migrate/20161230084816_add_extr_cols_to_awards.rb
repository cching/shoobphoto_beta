class AddExtrColsToAwards < ActiveRecord::Migration
  def change
  	add_column :awards, :add_period, :boolean
  	add_column :awards, :add_date, :boolean
  	add_column :awards, :submitted, :boolean
  	add_column :awards, :school_id, :integer
  end
end
