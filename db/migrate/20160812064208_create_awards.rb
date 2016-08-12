class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :title
      t.string :abbreviation
      t.string :awarded_for
      t.string :definition
      t.string :time_period
      t.date :award_date
      t.integer :export_list_id

      t.timestamps
    end

    add_column :export_lists, :uniq_id, :string
  end
end
