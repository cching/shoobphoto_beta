class AddAttachmentWatermarkToSeniorImages < ActiveRecord::Migration
  def self.up
    change_table :senior_images do |t|
      t.attachment :watermark
    end
  end

  def self.down
    remove_attachment :senior_images, :watermark
  end
end
