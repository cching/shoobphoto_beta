class AutoImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk, s3_key, auto)
   		@auto = Auto.find(auto) 
   		bucket = AWS::S3::Bucket.new('shoobphoto')
      	s3 = AWS::S3.new
      	chunk.each do |h|
      		unless h["ca_code"].nil? 
      			schools = School.where("ca_code like ?", "%#{h["ca_code"]}%")

      		if schools.any?
      			school = schools.last
      			packages = school.packages.where("lower(slug) like ?", "%#{h["slug"].downcase}%")
      		if packages.any? 
      			package = packages.last
	      	unless h["rec_type"].nil? || h["rec_type"] == ""
		        
					unless h["student_id"].nil?
						students = school.students.where(:student_id => "#{h["student_id"]}")

						@auto.increment!(:success_count) 

				          unless students.any?    
				            student = school.students.new(:student_id => h["student_id"], :access_code => h["accesscode"], :last_name => h["last_name"], :first_name => h["first_name"], :grade => h["grade"], :id_only => true, :access_code => h["accesscode"])
				            student.save
				           else
				           	student = students.last
				           	student.update(:student_id => h["student_id"], :access_code => h["accesscode"], :last_name => h["last_name"], :first_name => h["first_name"], :grade => h["grade"], :email => h["email"], :teacher => h["teacher"], :shoob_id => h["shoob_id"], :id_only => true, :access_code => h["accesscode"])
				          end

				          if h["rec_type"].downcase == 'master'
				          	image = package.student_images.new(:student_id => student.id, :image_file_name => h["url"], :folder => h["folder"], :grade => h["grade"], :url => h["url"], :shoob_id => h["shoob_id"])
				            image.index_file_name = "#{image.image_file_name}-index"
				            image.save
				          else

				          	images = student.student_images.where(:package_id => 6)

				          	unless images.any?
				          		image = package.student_images.new(:student_id => student.id, :image_file_name => h["url"], :folder => h["folder"], :grade => h["grade"], :url => h["url"], :shoob_id => h["shoob_id"])
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
				        		obj1 = bucket.objects["images/processed_watermarks/#{image.folder}/#{senior_image.image_file_name}.jpg"]
				                  obj2 = bucket.objects["images/watermarks/seniors/#{senior_image.id}/original/#{senior_image.image_file_name}.jpg"]
				                  obj1.copy_to(obj2)
				                  senior_image.update(:watermark_file_name => senior_image.image_file_name)
				        	end


			        end
		    	else #else rectype
			    	unless h["student_id"].nil?
			        student = school.students.find_by_student_id("#{h["student_id"]}")

			        @auto.increment!(:success_count)

				          unless student.present?     
				            student = school.students.new(:student_id => h["student_id"], :access_code => h["accesscode"], :last_name => h["last_name"], :first_name => h["first_name"], :grade => h["grade"], :email => h["email"], :teacher => h["teacher"], :shoob_id => h["shoob_id"], :id_only => true)
				            student.save
				           else
				           	student.update(:student_id => h["student_id"], :access_code => h["accesscode"], :last_name => h["last_name"], :first_name => h["first_name"], :grade => h["grade"], :email => h["email"], :teacher => h["teacher"], :shoob_id => h["shoob_id"], :id_only => true)
				          end 

				          images = student.student_images.where("lower(folder) like ?", "%#{h["folder"]}%")

				          	if images.any? #update
					        		image = images.last
				          			image = image.update(:package_id => package.id, :student_id => student.id, :image_file_name => h["url"], :url => h["url"], :folder => h["folder"], :shoob_id => h["shoob_id"])
					        else #create
					        		image = StudentImage.new(:package_id => package.id, :student_id => student.id, :image_file_name => h["url"], :url => h["url"], :folder => h["folder"], :shoob_id => h["shoob_id"])
					        		image.save
					     	end


				          if h["folder"] == "fall2017" || h["folder"] == "Fall2017"
				          	student.update(:enrolled => true)
				          end

				          unless h["url"].nil? || h["url"] == ""

				          obj1 = bucket.objects["images/processed_watermarks/#{image.folder}/#{image.image_file_name}.jpg"]
			                  obj2 = bucket.objects["images/watermarks/#{image.id}/watermark/#{image.image_file_name}.jpg"]
			                  obj1.copy_to(obj2)
			              end

				    end#end if no student id
			    end  # end rectype
			else #else packages
				@auto.student_errors.create(:priority => 0, :error_text => "#{h}", :error_description => "No package found with slug #{h["slug"]} for school #{h["ca_code"]} - check that the package exists for the school")
				@auto.increment!(:failed_count)
			end # end if no packages found

			else
				@auto.student_errors.create(:priority => 0, :error_text => "#{h}", :error_description => "No school found with CA code #{h["ca_code"]} - check that the CSV CA code matches exactly with the school's CA code on the site")
		        @auto.increment!(:failed_count)
		    end #end if no schools found
		end #end unless ca_code nil

     	end #end chunk loop


 	end #end def
end #end class


 