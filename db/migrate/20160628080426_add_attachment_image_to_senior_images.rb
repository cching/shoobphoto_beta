class AddAttachmentImageToSeniorImages < ActiveRecord::Migration
  def self.up
    change_table :senior_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :senior_images, :image
  end
end
