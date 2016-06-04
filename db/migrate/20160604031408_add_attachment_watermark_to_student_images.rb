class AddAttachmentWatermarkToStudentImages < ActiveRecord::Migration
  def self.up
    change_table :student_images do |t|
      t.attachment :watermark
    end
  end

  def self.down
    remove_attachment :student_images, :watermark
  end
end
