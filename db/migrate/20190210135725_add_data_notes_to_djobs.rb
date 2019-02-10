class AddDataNotesToDjobs < ActiveRecord::Migration
  def change
    add_column :djobs, :DATA_NOTES, :text
  end
end
