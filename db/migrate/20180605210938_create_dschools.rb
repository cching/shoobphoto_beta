class CreateDschools < ActiveRecord::Migration
  def change
    create_table :dschools do |t|
      t.string :scode
      t.string :name

      t.timestamps
    end
  end
end
