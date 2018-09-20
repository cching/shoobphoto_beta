class AddAvatarToDprojects < ActiveRecord::Migration
  def change
   
  end
  def up
    add_attachment :dprojects, :avatar
    add
  end
 
  def down
    remove_attachment :dprojects, :avatar
  end
end
