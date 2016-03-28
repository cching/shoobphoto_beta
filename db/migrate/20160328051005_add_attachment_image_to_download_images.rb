class AddAttachmentImageToDownloadImages < ActiveRecord::Migration
  def self.up
    change_table :download_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :download_images, :image
  end
end
