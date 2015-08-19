class AddAttachmentImageToExtras < ActiveRecord::Migration
  def self.up
    change_table :extras do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :extras, :image
  end
end
