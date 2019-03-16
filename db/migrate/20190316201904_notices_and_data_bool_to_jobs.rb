class NoticesAndDataBoolToJobs < ActiveRecord::Migration
  def change
    add_column :djobs, :NOTICES_YN, :boolean
    add_column :djobs, :DATA_YN, :boolean
  end
end
