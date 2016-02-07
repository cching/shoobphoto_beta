class CreateSchoolExports < ActiveRecord::Migration
  def change
    create_table :school_exports do |t|

      t.timestamps
    end
  end
end
