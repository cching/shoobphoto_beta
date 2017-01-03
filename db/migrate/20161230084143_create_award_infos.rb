class CreateAwardInfos < ActiveRecord::Migration
  def change
    create_table :award_infos do |t|
      t.string :awarded_for
      t.text :definition
      t.string :time_period
      t.date :award_date
      t.date :receive_by
      t.integer :export_list_id
      t.integer :award_id

      t.timestamps
    end

    create_table :award_infos_students do |t|
      t.integer :award_info_id
      t.integer :student_id
    end

  end
end
