class AddAttachmentPdfToItems < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.attachment :pdf
    end
  end

  def self.down
    remove_attachment :items, :pdf
  end
end
