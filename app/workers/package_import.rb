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

	      	unless h["rec_type"].nil?
		        
			unless h["student_id"].nil?
	        student = school.students.find_by_student_id("#{h["student_id"]}")

		          unless student.present?     
		            student = school.students.new(:student_id => h["student_id"], :last_name => h["last_name"], :first_name => h["first_name"], :grade => h["grade"], :id_only => true)
		            student.save
		           else
		           	student.update(:student_id => h["student_id"], :last_name => h["last_name"], :first_name => h["first_name"], :grade => h["grade"], :email => h["email"], :teacher => h["teacher"], :shoob_id => h["shoob_id"], :id_only => true)
		          end

		          if h["rec_type"] == 'master'
		          	image = package.student_images.new(:student_id => student.id, :image_file_name => h["url"], :folder => h["folder"], :grade => h["grade"], :url => h["url"])
		            image.index_file_name = "#{image.image_file_name}-index"
		            image.save
		          else

		          	images = student.student_images.where(:package_id => 6)

		          	unless images.any?
		          		image = package.student_images.new(:student_id => student.id, :image_file_name => h["url"], :folder => h["folder"], :grade => h["grade"], :url => h["url"])
		            	image.index_file_name = "#{image.image_file_name}-index"
		            	image.save
		            else
		            	image = images.last
		        	end
		        	end

		          senior_image = image.senior_images.create(:url => h["url"], :image_file_name => h["url"])

		          unless senior_image.image.exists?
		        		senior_image.update(:image_file_name => senior_image.image_file_name.downcase)
		        	end

		        	unless senior_image.image.exists?
		        		senior_image.update(:image_file_name => senior_image.image_file_name.upcase)
		        	end

		        	if senior_image.image.exists?
		        		obj1 = bucket.objects["images/#{image.folder}/#{senior_image.image_file_name}.jpg"]
		                  obj2 = bucket.objects["images/watermarks/seniors/#{senior_image.id}/original/#{senior_image.image_file_name}.jpg"]
		                  obj1.copy_to(obj2)
		                  senior_image.update(:watermark_file_name => senior_image.image_file_name)
		                  senior_image.watermark.reprocess!
		        	end


	        end
		    	else
		    	unless h["student_id"].nil?
		        student = school.students.find_by_student_id("#{h["student_id"]}")

			          unless student.present?     
			            student = school.students.new(:student_id => h["student_id"], :last_name => h["last_name"], :first_name => h["first_name"], :grade => h["grade"], :email => h["email"], :teacher => h["teacher"], :shoob_id => h["shoob_id"], :id_only => true)
			            student.save
			           else
			           	student.update(:student_id => h["student_id"], :last_name => h["last_name"], :first_name => h["first_name"], :grade => h["grade"], :email => h["email"], :teacher => h["teacher"], :shoob_id => h["shoob_id"], :id_only => true)
			          end

			          image = package.student_images.new(:student_id => student.id, :image_file_name => h["url"], :folder => h["folder"], :grade => h["grade"], :url => h["url"], :url2 => h["url2"], :url3 => h["url3"], :url4 => h["url4"], :url1 => h["url1"] )
			          image.index_file_name = "#{image.image_file_name}-index"
			          image.save
			        end
		        
		    end #end unless
     	end #end chunk loop
 	end #end def
end #end class


 