class AddAttachmentWatermarkToDownloadImages < ActiveRecord::Migration
  def self.up
    change_table :download_images do |t|
      t.attachment :watermark
    end
  end

  def self.down
    remove_attachment :download_images, :watermark
  end
end
