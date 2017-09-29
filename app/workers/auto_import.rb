class AutoImport
 	include Sidekiq::Worker 
 	sidekiq_options queue: "package_import"

  	def perform(auto)
   		@auto = Auto.create(:success_count => 0, :failed_count => 0)
   		bucket = AWS::S3::Bucket.new('shoobphoto')
      	s3 = AWS::S3.new
      	    objects = bucket.objects.with_prefix('AutoCSV/output').collect(&:key).drop(1)

      	    s3_array = []

      	    objects.each do |object|
		      s3_array << "AutoCSV/import/#{object}"

		      obj1 = bucket.objects["#{object}"]
	          obj2 = bucket.objects["AutoCSV/import/#{object}"]
	          obj1.copy_to(obj2)
	          obj1.delete
		  	end

		    s3_array.each do |s3_csv|
		      csv_path  = "https://s3-us-west-1.amazonaws.com/shoobphoto/#{s3_csv}"

		      csv_file  = open(csv_path,'r')

		      chunk = SmarterCSV.process(csv_file, {:file_encoding =>'iso-8859-1'}) do |chunk|
		      	      	chunk.each do |h|
		      	      		school = School.where(:id => h[:school_id].to_i)
				      		
				      		if school.any?
				      			school = school.last
				      			unless school.enrolled?
 		      	      				school.students.update_all(enrolled: false)
 	      	      					school.update(enrolled: true)
 		      	      			end

 		      	      			unless school.clear_teachers?
						          	school.educators.destroy_all
						          	school.update(clear_teachers: true)
						        end
				      			
				      		package = Package.find(h[:package_id].to_i)
				      		## import senior images
					      	if package.id == 6
						        
									unless h[:student_id].nil?
										students = school.students.where(:student_id => "#{h[:student_id]}").where(:id_only => true)

										@auto.increment!(:success_count) 

								        unless students.any?    
								            student = school.students.new(:student_id => h[:student_id], :last_name => h[:last_name], :first_name => h[:first_name], :grade => h[:grade], :id_only => true, :shoob_id => h[:shoob_id])
								            student.save
								        else
								           	student = students.last
								           	student.update(:student_id => h[:student_id], :last_name => h[:last_name], :first_name => h[:first_name], :grade => h[:grade], :email => h[:email], :teacher => h[:teacher], :shoob_id => h[:shoob_id], :id_only => true)

								        end


								        images = student.student_images.where(["package_id = ? and load_id = ?", 6, "#{h[:load_id]}"])
								        if images.any?
								            image = images.last
								        else
								        	image = package.student_images.new(:package_id => 6, :load_id => h[:load_id],:student_id => student.id, :image_file_name => h[:url], :folder => h[:folder], :grade => h[:grade], :url => h[:url], :shoob_id => h[:shoob_id], :accesscode => h[:accesscode])
								            image.index_file_name = "#{image.image_file_name}-index" 
								            image.save
								        end

								        senior_image = image.senior_images.create(:url => h[:url], :image_file_name => h[:url], :extension => h[:extension])

							        	if senior_image.image.exists?
							        		obj1 = bucket.objects["images/processed_watermarks/#{image.folder}/#{senior_image.image_file_name}#{senior_image.extension}"]
							                obj2 = bucket.objects["images/watermarks/seniors/#{senior_image.id}/original/#{senior_image.image_file_name}#{senior_image.extension}"]
							                obj1.copy_to(obj2)
							                senior_image.update(:watermark_file_name => senior_image.image_file_name)
							        	end
							        end
						    	else #else rectype
						    		#import normal student images
							    	unless h[:student_id].nil?
							        students = school.students.where(:student_id => "#{h[:student_id]}").where(:id_only => true)

							        @auto.increment!(:success_count)

							          unless students.any?     
							            student = school.students.new(:student_id => h[:student_id], :last_name => h[:last_name], :first_name => h[:first_name], :grade => h[:grade], :email => h[:email], :teacher => h[:teacher], :shoob_id => h[:shoob_id], :id_only => true)
							            student.save
							           else
							           	student = students.last
							           	student.update(:student_id => h[:student_id], :last_name => h[:last_name], :first_name => h[:first_name], :grade => h[:grade], :email => h[:email], :teacher => h[:teacher], :shoob_id => h[:shoob_id], :id_only => true)
							          end 

							         

							          unless h[:teacher].nil?
							          	educators = school.educators.where("name like ?", "%#{h[:teacher]}%")
							          	if educators.any?
							          		educator = educators.last
							          		puts "@@@@@ educator found #{educator.id}"
							          	else
							          		educator = school.educators.create(:name => h[:teacher])
							          		puts "@@@@@@@@ educator created #{educator.id}"
							          	end

							          	student.update(:educator_id => educator.id)
							          		puts "@@@@@@@@@ student #{student.id} updated with #{educator.id}"
							          else 
							          	puts "@@@@@@@@ teacher nil"
							          end


			 
							          images = student.student_images.where("lower(folder) like ?", "%#{h[:folder]}%")

							          	if images.any? #update
							        		image = images.last
							        		if h[:url].nil?
						          			else
						          				image.update(:accesscode => h[:accesscode],:package_id => package.id, :student_id => student.id, :image_file_name => h[:url], :watermark_file_name => h[:url], :url => h[:url], :folder => h[:folder], :shoob_id => h[:shoob_id])
						          			end
								        else #create
							        		if h[:url].nil?
							        			image = StudentImage.new(:accesscode => h[:accesscode], :package_id => package.id, :student_id => student.id, :url => h[:url], :folder => h[:folder], :shoob_id => h[:shoob_id])
							        		else
							        			image = StudentImage.new(:accesscode => h[:accesscode], :package_id => package.id, :student_id => student.id, :image_file_name => h[:url], :watermark_file_name => h[:url], :url => h[:url], :folder => h[:folder], :shoob_id => h[:shoob_id], :extension => h[:extension])

							        		end
							        		image.save
								     	end

									     	if image.image.exists?
									           	if Student.qualified(student) && Order.qualified(student) 
									           		filter_orders(student, package.id, image)
									           	end
								           		#need to check each order, mark order package as downloaded true
									     	end


								          if h[:folder] == "fall2018" || h[:folder] == "Fall2018"
								          	student.update(:enrolled => true)
								          end

								          unless h[:url].nil? || h[:url] == ""

								          obj1 = bucket.objects["images/processed_watermarks/#{image.folder}/#{image.image_file_name}#{image.extension}"]
							                  obj2 = bucket.objects["images/watermarks/#{image.id}/watermark/#{image.image_file_name}#{image.extension}"]
							                  obj1.copy_to(obj2)
							              end

								    end#end if no student id
							    end  # end rectype
							end
				     	end #end chunk loop
		      end
		 
		    end 

		    s3_array.each do |object| #clear database csv
		      obj = s3.buckets['shoobphoto'].objects[object] # no request made
		      obj.delete
		    end


 	end #end def

 	def filter_orders(student, package_id, image)
 		student.carts.each do |cart|
	      if cart.orders.any?
	        order = cart.orders.last #shouldn't loop through all order packages, just find order package that have packages from uploaded image

	        order.order_packages.where(email_sent: false).where(:student_id => student.id).where(:package_id => package_id).each do |op|
	        	if op.options.any?
	        		if op.options.first.download? && op.student_image_id.nil?
	        			if !op.cart.email.nil?
	        				ImageMailer.send_image(op, image).deliver
	        			end
	        		end
	        	end
	        end

	      end
	    end
 		#mark as email sent
 	end
end #end class


 