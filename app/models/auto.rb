class Auto < ActiveRecord::Base
	has_many :student_errors

	def self.check_orders
		s3 = AWS::S3.new
		File.open("/Users/alexshoob/desktop/scanned_orders/result.csv", "w") do |result|
			count = OrderPackage.where("scanned = false OR qualified = true AND email_sent = false").count
			result << "order ID, school, student ID, firstname, lastname, pricelist, date, email, scanned, qualified"
			result << "\n"
			OrderPackage.where("scanned = false OR qualified = true AND email_sent = false").each_with_index do |order_package, i|
				order_package.update(:scanned => true)
				unless order_package.student.nil?
			    if Student.qualified(order_package.student) && Order.qualified(order_package.student) 
			       	if order_package.options.any?
		        		if order_package.options.first.download? && order_package.student_image_id.nil? && order_package.cart.orders.any?
		        			order_package.update(:qualified => true)

		        			result << "#{order_package.cart.orders.first.id}, #{order_package.student.school.try(:name)}, #{order_package.student.student_id}, #{order_package.student.first_name}, #{order_package.student.last_name}, #{order_package.package.slug}, #{order_package.cart.created_at}, #{order_package.cart.orders.first.email}, true, #{order_package.qualified}"
		        			puts "Qualified order found: #{i} added out of #{count} to scan"
		        			result << "\n"
		        		end
		        	end
			    end
			end
		 	end
		 end

		obj = s3.buckets['shoobphoto'].objects["AutoCSV/scan/result.csv"]
	    obj.write(File.read("/Users/alexshoob/desktop/scanned_orders/result.csv"))
	    puts "Uploading CSVs to S3..."
	end
 
	  def self.upload
	    if Dir.glob("/Volumes/6TB-J-12-13/Diglab2017/Dbf/csv/*.csv").any?

	      #clear previous images from transfer

	      s3 = AWS::S3.new
	      encoding_options = {
	        :invalid           => :replace,  # Replace invalid byte sequences
	        :undef             => :replace,  # Replace anything not defined in ASCII
	        :replace           => '',        # Use a blank for those replacements
	        :universal_newline => true       # Always break lines with \n
	      }
	      

	      i = 1 # set index counter
	      student_index = 0

	      @load_id = SecureRandom.hex

	      processed = []

	      failed_filename = "#{@load_id}_failed.csv"
	      output_filename = "#{@load_id}_output.csv"
	          File.open("/Users/alexshoob/load_station/output/#{output_filename}", "w") do |output| #initiate output CSV 
	            File.open("/Users/alexshoob/desktop/load_station_failed/#{failed_filename}", "w") do |failed| #initiate failed CSV 

	              Dir.glob("/Volumes/6TB-J-12-13/Diglab2017/Dbf/csv/*.csv") do |fname|

	              	processed << fname

	                if i == 1 #set headers for first iteration

	                    @output = []
	                    @failed = []

	                        output <<  "url, extension, student_id, accesscode, last_name, first_name, grade, folder, email, dob, teacher, school_id, package_id, shoob_id, rec_type, load_id"
	                        output << "\n"
	                        failed <<  "Reason, url, student_id, acesscode, last_name, first_name, grade, folder, email, dob, teacher, ca_code, rec_type, load_id"
	                        failed << "\n"

	                      end

	                        @csv = SmarterCSV.process(fname, options={:file_encoding =>'iso-8859-1'}) do |chunk| #goes through file to upload images from local network
	                          chunk.each do |h|
	                            student_index = student_index + 1
	                            unless h[:ca_code].nil? 
					      			schools = School.where("ca_code like ?", "%#{h[:ca_code]}%")

						      		if schools.any?
						      			school = schools.last
						      			unless h[:slug].nil?
						      			packages = school.packages.where(hidden: false).where("lower(slug) like ?", "%#{h[:slug].downcase}%")
						      			if packages.any? 
						      				package = packages.last
				                            unless h[:url].nil? || h[:url] == ""
				                            	url = "#{h[:url]}".gsub("\\","\/").to_s
				                            	url_array = url.split("\/") 
				                            	url_path = "/Volumes/6TB-J-12-13" #convert windows path to mac

				                            	url_index = 1
				                            	until url_array.count == url_index
				                            		url_path = url_path + "/#{url_array[url_index]}"
				                            		url_index += 1
				                            	end
				                              if File.exists?("#{url_path}")
				                                file_name = File.basename(url_path, ".*")			                          
				                                extension = File.extname(url_path).downcase
				                                if extension == ""
				                                	extension = ".jpg"
				                                end
				                                basename = file_name.downcase

				                                Auto.watermark_images(url_path, h[:folder], basename, extension, s3, student_index, i, school)
				                                @failed << false
				                                @output << true
				                                response = "#{basename}, #{extension}, #{h[:student_id]}, #{h[:accesscode]}, #{h[:last_name]}, #{h[:first_name]}, #{h[:grade]}, #{h[:folder]}, #{h[:email]}, #{h[:dob]}, #{h[:teacher]}, #{school.id}, #{package.id}, #{h[:shoob_id]}, #{h[:rec_type]}, #{@load_id}".encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
				                                output << response.encode(Encoding.find('ASCII'), encoding_options)
				                                output << "\n"
				                                
				                              else #no image found on local server
				                                #write error file
				                                @failed << true
				                                @output << false
				                                response = "Unable to locate student image in local path #{url_path} for school #{school.name}, #{url_path}, #{h[:student_id]}, #{h[:acesscode]}, #{h[:last_name]}, #{h[:first_name]}, #{h[:grade]}, #{h[:folder]}, #{h[:email]}, #{h[:dob]}, #{h[:teacher]}, #{h[:ca_code]}, #{h[:rec_type]}, h#{@load_id}"
				                                failed << response.encode(Encoding.find('ASCII'), encoding_options)
				                                failed << "\n"

				                                response = ", , #{h[:student_id]}, #{h[:accesscode]}, #{h[:last_name]}, #{h[:first_name]}, #{h[:grade]}, #{h[:folder]}, #{h[:email]}, #{h[:dob]}, #{h[:teacher]}, #{school.id}, #{package.id}, #{h[:shoob_id]}, #{h[:rec_type]}, #{@load_id}".encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
				                                output << response.encode(Encoding.find('ASCII'), encoding_options)
				                                output << "\n"

				                                puts "Unable to locate student image #{student_index} for school #{school.name}"
				                              end #end if file exists
				                            else #url is blank, load empty kid


				                              puts "Student #{student_index} for school #{school.name} has no image. Adding to CSV."

				                              @failed << false
				                                @output << true
				                                response = ", , #{h[:student_id]}, #{h[:accesscode]}, #{h[:last_name]}, #{h[:first_name]}, #{h[:grade]}, #{h[:folder]}, #{h[:email]}, #{h[:dob]}, #{h[:teacher]}, #{school.id}, #{package.id}, #{h[:shoob_id]}, #{h[:rec_type]}, #{@load_id}".encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
				                                output << response.encode(Encoding.find('ASCII'), encoding_options)
				                                output << "\n"

				                            end #end unless
				                        else #if no packages found for school 
				                        	@failed << true
			                                @output << false
			                                response = "No package found with slug #{h[:slug]} for school #{school.name} - availabile: #{school.packages.where(hidden: false).map(&:slug).join(', ')}, #{url_path}, #{h[:student_id]}, #{h[:acesscode]}, #{h[:last_name]}, #{h[:first_name]}, #{h[:grade]}, #{h[:folder]}, #{h[:email]}, #{h[:dob]}, #{h[:teacher]}, #{h[:ca_code]}, #{h[:rec_type]}, h#{@load_id}"

			                                failed << response.encode(Encoding.find('ASCII'), encoding_options)
			                                failed << "\n"

				                        end
				                    else
				                    	@failed << true
			                                @output << false
			                                response = "No slug provided, #{url_path}, #{h[:student_id]}, #{h[:acesscode]}, #{h[:last_name]}, #{h[:first_name]}, #{h[:grade]}, #{h[:folder]}, #{h[:email]}, #{h[:dob]}, #{h[:teacher]}, #{h[:ca_code]}, #{h[:rec_type]}, h#{@load_id}"

			                                failed << response.encode(Encoding.find('ASCII'), encoding_options)
			                                failed << "\n"
			                            end
				                    else #if no school found with ca code
				                    	@failed << true
		                                @output << false
		                                response = "No school found with CA code #{h[:ca_code]}, #{url_path}, #{h[:student_id]}, #{h[:acesscode]}, #{h[:last_name]}, #{h[:first_name]}, #{h[:grade]}, #{h[:folder]}, #{h[:email]}, #{h[:dob]}, #{h[:teacher]}, #{h[:ca_code]}, #{h[:rec_type]}, h#{@load_id}"
		                                failed << response.encode(Encoding.find('ASCII'), encoding_options)
		                                failed << "\n"
				                    end
				                else #if no ca_code
				                	@failed << true
	                                @output << false
		                            response = "No CA code given, #{url_path}, #{h[:student_id]}, #{h[:acesscode]}, #{h[:last_name]}, #{h[:first_name]}, #{h[:grade]}, #{h[:folder]}, #{h[:email]}, #{h[:dob]}, #{h[:teacher]}, #{h[:ca_code]}, #{h[:rec_type]}, h#{@load_id}"
	                                failed << response.encode(Encoding.find('ASCII'), encoding_options)
	                                failed << "\n"
				                end
	                          end #end chunk
	                        end #end smarter csv process
	                     
	                  i = i + 1
	                  student_index = 0
	                end #end file loop

	                end  #close failed
	                end #close output

	      #cleanup and upload

	      if @output.include? true
	        obj = s3.buckets['shoobphoto'].objects["AutoCSV/output/#{output_filename}"]
	        obj.write(File.read("/Users/alexshoob/load_station/output/#{output_filename}"))
	        puts "Uploading CSVs to S3..."
	      end  

	      unless @output.include? true
	      	File.delete("/Users/alexshoob/load_station/output/#{output_filename}")
	      end

	      unless @failed.include? true
	      	File.delete("/Users/alexshoob/desktop/load_station_failed/#{failed_filename}")
	      else
	      	puts "There may be #{@failed.count(true)} errors. Please check the folder on your desktop for more information: filename #{failed_filename}"
	      end

	    puts "Initiating transfer of CSVs from S3 to site for load..."
	    AutoImport.perform_async(1) #Initiate upload to site
	    puts "All CSVs loaded successfully. They are currently being imported into the site."

	    begin
		    processed.each { |f| File.delete(f) } #cleanup
		rescue
		  	puts "ALERT: CSV and images were uploaded to site correctly. Unable to delete loaded CSVs from ~/Diglab2017/Dbf/csv/. Please manually delete CSVs before loading in more."
		end
	    end # end if any csv files exist
	     
	  end

	  def self.watermark_images(url, folder, basename, extension, s3, student_index, i, school)
	  	img = Magick::Image.read("#{url}").first
        mark = Magick::Image.read("/Users/alexshoob/load_station/watermark.png").first
        mark.background_color = "Transparent"
        watermark = mark.resize_to_fit(img.rows, img.columns.to_f)


        img2 = img.dissolve(watermark, 0.75, 1, Magick::CenterGravity)
        img2.write("/Users/alexshoob/load_station/watermarks/#{basename}#{extension}")

        img3 = img.resize_to_fit(28, 35)
        img3.write("/Users/alexshoob/load_station/index/#{basename}#{extension}")

        obj_watermark = s3.buckets['shoobphoto'].objects["images/processed_watermarks/#{folder}/#{basename}#{extension}"] # no request made
        File.open("/Users/alexshoob/load_station/watermarks/#{basename}#{extension}", "rb") do |watermarked_image|
          obj_watermark.write(watermarked_image)
        end

        obj_index = s3.buckets['shoobphoto'].objects["images/processed_index/#{folder}/#{basename}#{extension}"] # no request made
        File.open("/Users/alexshoob/load_station/index/#{basename}#{extension}", "rb") do |index_image|
          obj_index.write(index_image)
        end

        File.delete("/Users/alexshoob/load_station/watermarks/#{basename}#{extension}")
        File.delete("/Users/alexshoob/load_station/index/#{basename}#{extension}")

        puts "Watermarking and indexing images for student #{student_index} for #{school.name}. Uploading to S3..."

        obj = s3.buckets['shoobphoto'].objects["images/#{folder}/#{basename}#{extension}"] # no request made
        obj.write(File.open("#{url}")) #Writes image found to s3
	  end
end
