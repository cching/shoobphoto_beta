class DownloadImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk, school_id)
  		@school = School.last

      	chunk.each do |h|
      		students = @school.students.where(:student_id => h["st_stu_id"])
      		package = Package.where(:slug => h["pricelist"]).last
	    	unless students.any?
	           students.last.download_images.create(:shoob_id => h["id"], :package_id => package.try(:id), :year => h["year"], :folder => ["folder"], :url => ["st_id"])
	         end	          	
	        
     	end #end chunk
 	end
end

