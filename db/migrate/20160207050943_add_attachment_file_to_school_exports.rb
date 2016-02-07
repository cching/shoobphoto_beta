class AddAttachmentFileToSchoolExports < ActiveRecord::Migration
  def self.up
    change_table :school_exports do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :school_exports, :file
  end
end
