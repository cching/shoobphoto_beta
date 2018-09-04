class AddSignaturetoDprojects < ActiveRecord::Migration
  def change
    add_column :dprojects, :signature, :string
  end
end
