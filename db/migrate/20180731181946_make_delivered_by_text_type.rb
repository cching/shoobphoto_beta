class MakeDeliveredByTextType < ActiveRecord::Migration
  def change
  	change_column :dprojects, :delivered_by, :text
  end
end
