class CreateSchoolTemplates < ActiveRecord::Migration
  def change
    create_table :school_templates, :id => false do |t|
      t.integer :school_id
      t.integer :type_id
    end
  end
end
