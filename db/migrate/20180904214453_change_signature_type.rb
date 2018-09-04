class ChangeSignatureType < ActiveRecord::Migration
  def change
    change_column :dprojects, :signature, :text
  end
end
