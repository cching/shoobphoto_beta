class DownloadImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk, school_id)
  		@school = School.find(school_id)

      	chunk.each do |h|
      		students = @school.students.find_by_student_id("#{h["st_stu_id"]}")
	    	unless students.nil?
	    		package = Package.find_by_slug("#{h["pricelist"]}")
	    		unless h["st_id"].nil?
	    			year = h["folder"][-4..-1]
			        i = students.download_images.create(:shoob_id => h["id"], :package_id => package.try(:id), :year => year, :folder => h["folder"], :url => h["st_id"].downcase)     
		    	end
	         end	          	
	        
     	end #end chunk
 	end
end

