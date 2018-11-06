class FileAttachments < ActiveRecord::Migration
  def self.up
    add_attachment :afiles, :dfile
  end
  
  def self.down
    remove_attachment :afiles, :dfile
  end
end
