class CreateDprojects < ActiveRecord::Migration
  def change
    create_table :dprojects do |t|

      t.timestamps
    end
  end
end
