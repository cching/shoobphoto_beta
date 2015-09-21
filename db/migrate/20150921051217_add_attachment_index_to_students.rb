class AddAttachmentIndexToStudents < ActiveRecord::Migration
  def self.up
    change_table :student_images do |t|
      t.attachment :index
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :student_images, :index
  end
end
