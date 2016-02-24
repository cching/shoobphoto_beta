class AddCacheToSchoolsYearbook < ActiveRecord::Migration
  def change
  	  add_column :schools, :yearbook_ids, :text

  end
end
