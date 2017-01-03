class AddIndexToAwardInfo < ActiveRecord::Migration
  def change
  	add_column :award_infos, :index, :integer
  end
end
