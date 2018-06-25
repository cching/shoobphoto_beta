class AddDfileToDprojects < ActiveRecord::Migration
  def self.up
  	add_attachment :dprojects, :dfile
  end

  def self.down
  	remove_attachment :dprojects, :dfile
  end
end
