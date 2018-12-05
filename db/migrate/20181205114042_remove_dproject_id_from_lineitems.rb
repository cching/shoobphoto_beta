class RemoveDprojectIdFromLineitems < ActiveRecord::Migration
  def change
    remove_column :lineitems, :dproject_id, :integer
  end
end
