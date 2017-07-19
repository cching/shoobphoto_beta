class AddAttachmentImageToBackgrounds < ActiveRecord::Migration
  def self.up
    change_table :backgrounds do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :backgrounds, :image
  end
end
