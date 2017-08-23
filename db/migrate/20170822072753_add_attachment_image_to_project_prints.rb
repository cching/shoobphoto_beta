class AddAttachmentImageToProjectPrints < ActiveRecord::Migration
  def self.up
    change_table :project_prints do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :project_prints, :image
  end
end
