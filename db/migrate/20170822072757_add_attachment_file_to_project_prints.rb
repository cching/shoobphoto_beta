class AddAttachmentFileToProjectPrints < ActiveRecord::Migration
  def self.up
    change_table :project_prints do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :project_prints, :file
  end
end
