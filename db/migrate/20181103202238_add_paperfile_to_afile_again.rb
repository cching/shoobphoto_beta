class AddPaperfileToAfile < ActiveRecord::Migration
  def self.up
    add_attachment :afiles, :paperfile
  end
  
  def self.down
    remove_attachment :afiles, :paperfile
  end
end