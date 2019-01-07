class AddCommentsToDattachments < ActiveRecord::Migration
  def change
    add_column :dattachments, :dcomment, :text
  end
end
