class AddGradeToCorder < ActiveRecord::Migration
  def change
  	add_column :corders, :grade, :string
  end
end
