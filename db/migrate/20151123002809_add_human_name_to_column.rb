class AddHumanNameToColumn < ActiveRecord::Migration
  def change
  	add_column :columns, :type, :string
  end
end
