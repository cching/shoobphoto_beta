class AddAttachmentImageToAwards < ActiveRecord::Migration
  def self.up
    change_table :awards do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :awards, :image
  end
end
