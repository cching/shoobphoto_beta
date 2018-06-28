class AddAttachmentToDattachments < ActiveRecord::Migration
  def self.up
  	add_attachment :dattachments, :project_attachment
  end

  def self.down
  	remove_attachment :dattachments, :project_attachment
  end
end
