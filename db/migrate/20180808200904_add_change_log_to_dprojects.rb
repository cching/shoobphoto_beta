class AddChangeLogToDprojects < ActiveRecord::Migration
  def change
    add_column :dprojects, :change_log, :text
  end
end
