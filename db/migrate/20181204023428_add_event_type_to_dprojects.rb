class AddEventTypeToDprojects < ActiveRecord::Migration
  def change
    add_column :dprojects, :event_type, :string
  end
end
