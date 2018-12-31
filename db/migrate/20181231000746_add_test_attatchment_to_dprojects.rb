class AddTestAttatchmentToDprojects < ActiveRecord::Migration
  def self.up
    add_attachment :dprojects, :testattachment
  end

  def self.down
    remove_attachment :dprojects, :testattachment
  end
end
