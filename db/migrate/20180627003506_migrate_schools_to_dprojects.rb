class MigrateSchoolsToDprojects < ActiveRecord::Migration
	class Dproject < ActiveRecord::Base; end
	class School < ActiveRecord::Base; end
  def change
  	Dproject.all.each do |dproject|
  		dproject.update(school_id: dproject.scode.to_i)
  	end
  end
end
