class AddPosesToPackageOption < ActiveRecord::Migration
  def change
  	add_column :options, :poses, :integer
  end
end
