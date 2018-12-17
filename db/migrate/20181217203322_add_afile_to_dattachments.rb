class AddAfileToDattachments < ActiveRecord::Migration
  def self.up
    add_attachment :dattachments, :afile
  end
  
  def self.down
    remove_attachment :dattachments, :afile
  end
end
