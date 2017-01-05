class AddAwardInfoIdToAward < ActiveRecord::Migration
  def change
  	add_column :award_infos, :award_info_id, :integer
  end
end
