class AddStatusToDjobs < ActiveRecord::Migration
  def change
    add_column :djobs, :status, :string
  end
end
