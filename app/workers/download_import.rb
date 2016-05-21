class DownloadImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk, school_id)
  		@school = School.find(school_id)

      	chunk.each do |h|
      		students = @school.students.find_by_student_id("#{h["st_stu_id"]}")
	    	unless students.nil?
	    		package = Package.find_by_slug("#{h["pricelist"]}")
	    		if students.download_images.where(:folder => h["folder"]).any?
	    			i = students.download_images.where(:folder => h["folder"]).last
	    			i.update(:shoob_id => h["id"], :package_id => package.try(:id), :year => h["year"], :url => h["st_id"])
	    		else
		           i = students.download_images.create(:shoob_id => h["id"], :package_id => package.try(:id), :year => h["year"], :folder => h["folder"], :url => h["st_id"])
		           
		        end
		        i.update(:image_file_name => i.url.downcase)
	         end	          	
	        
     	end #end chunk
 	end
end

