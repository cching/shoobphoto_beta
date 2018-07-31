class MakeReievedByTextType < ActiveRecord::Migration
  def change
  	change_column :dprojects, :recieved_by, :text
  end
end
