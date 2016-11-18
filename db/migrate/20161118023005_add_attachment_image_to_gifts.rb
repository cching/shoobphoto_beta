class AddAttachmentImageToGifts < ActiveRecord::Migration
  def self.up
    change_table :gifts do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :gifts, :image
  end
end
