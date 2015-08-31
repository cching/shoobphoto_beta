class AddAttachmentMainToImages < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.attachment :main
    end
  end

  def self.down
    remove_attachment :items, :main
  end
end
