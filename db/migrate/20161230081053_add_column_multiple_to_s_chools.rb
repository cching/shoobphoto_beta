class AddColumnMultipleToSChools < ActiveRecord::Migration
  def change
  	add_column :schools, :multiple, :boolean, default: false
  end
end
