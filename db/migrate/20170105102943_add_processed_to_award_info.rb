class AddProcessedToAwardInfo < ActiveRecord::Migration
  def change
  	add_column :award_infos, :processed, :boolean, default: false
  end
end
