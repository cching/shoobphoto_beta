class CreateSchoolPackages < ActiveRecord::Migration
  def change
    create_table :school_packages do |t|
      t.integer :package_id
      t.integer :school_id

      t.timestamps
    end
  end
end
