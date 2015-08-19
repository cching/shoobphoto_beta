class RemoveTimestampsFromItems < ActiveRecord::Migration
  def up
  	remove_column :items, :created_at
  	remove_column :items, :updated_at
  end
end
