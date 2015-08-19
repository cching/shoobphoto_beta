class AddStudentIdColumnToCarts < ActiveRecord::Migration
  def up
  	add_column :carts, :id_supplied, :boolean, default: true
  end
end
