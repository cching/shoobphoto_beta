class AddAttachmentImageToOptions < ActiveRecord::Migration
  def self.up
    change_table :packages do |t|
      t.attachment :banner
    end
  end

  def self.down
    remove_attachment :packages, :banner
  end
end
