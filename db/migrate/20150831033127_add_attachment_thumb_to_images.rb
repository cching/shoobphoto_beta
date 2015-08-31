class AddAttachmentThumbToImages < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.attachment :thumb
    end
  end

  def self.down
    remove_attachment :items, :thumb
  end
end
