class PackageImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk, package_id, school_id)
    	package = Package.find(package_id) 
   		school = School.find(school_id)
   		bucket = AWS::S3::Bucket.new('shoobphoto')
      	s3 = AWS::S3.new
      	bucket1 = s3.buckets["shoobphoto"]
      	chunk.each do |h|


		    	unless h["student_id"].nil?
		        student = school.students.find_by_student_id("#{h["student_id"]}")

			          if student.present?     
			          	images = student.student_images.where(:folder => "#{h["folder"]}")

			          	if images.any?
			          		image = images.last

			           		image.update(:shoob_id => h["shoob_id"])
			           	end
			          end

			        end
		        
     	end #end chunk loop
 	end #end def
end #end class


 