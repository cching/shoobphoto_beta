class AddAttachmentFileToContacts < ActiveRecord::Migration
  def self.up
    change_table :contacts do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :contacts, :file
  end
end
