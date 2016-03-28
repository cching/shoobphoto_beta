class DownloadImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk, school_id)
  		@school = School.find(school_id)

      	chunk.each do |h|
      		students = @school.students.find_by_student_id(h["st_stu_id"])
      		package = Package.find_by_slug(h["pricelist"])
	    	if students.any?
	           students.last.download_images.create(:shoob_id => h["id"], :package_id => package.try(:id), :year => h["year"], :folder => ["folder"], :url => ["st_id"])
	         end	          	
	        
     	end #end chunk
 	end
end

