class AddSfileToDattachments < ActiveRecord::Migration
  def self.up
    add_attachment :dattachments, :sfile
  end
  
  def self.down
    remove_attachment :dattachments, :sfile
  end
end