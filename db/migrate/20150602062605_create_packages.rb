class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :package
      t.integer :package_type

      t.timestamps
    end
  end
end
