class AddPCodeToLineItems < ActiveRecord::Migration
  def change
    add_column :lineitems, :p_code, :integer
  end
end
