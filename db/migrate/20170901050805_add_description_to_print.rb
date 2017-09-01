class AddDescriptionToPrint < ActiveRecord::Migration
  def change
  	add_column :prints, :description, :string
  end
end
