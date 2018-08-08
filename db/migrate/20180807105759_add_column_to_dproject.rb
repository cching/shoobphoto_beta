class AddColumnToDproject < ActiveRecord::Migration
  def change
  	add_column :dprojects, :signature, :string
  end
end
