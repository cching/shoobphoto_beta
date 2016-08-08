class CreateAutos < ActiveRecord::Migration
  def change
    create_table :autos do |t|

      t.timestamps
    end
  end
end
