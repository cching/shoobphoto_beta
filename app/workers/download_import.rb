class DownloadImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk, school_id)
  		@school = School.find(school_id)

      	chunk.each do |h|
      		students = @school.students.find_by_student_id("#{h["st_stu_id"]}")
      		package = Package.find_by_slug(h["pricelist"])
	    	       	
	        
     	end #end chunk
 	end
end

