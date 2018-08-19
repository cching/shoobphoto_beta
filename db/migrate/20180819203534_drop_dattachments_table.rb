class DropDattachmentsTable < ActiveRecord::Migration
  def change
    drop_table :dattachments
  end
end
