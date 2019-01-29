class AddReConfToDjobsChange < ActiveRecord::Migration
  def change
    change_column :djobs, :RECONF, :string
  end
end
