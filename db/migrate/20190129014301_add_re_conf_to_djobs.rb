class AddReConfToDjobs < ActiveRecord::Migration
  def change
    add_column :djobs, :RECONF, :text
    add_column :djobs, :RECONFYN, :boolean
  end
end
