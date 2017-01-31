class Auto < ActiveRecord::Base
	has_many :student_errors

	  def self.upload
	    if Dir.glob("J:/Diglab2010/Dbf/CSV/*.csv").any?

	      #clear previous images from transfer

	      FileUtils.rm_rf("C:/Sites/Rails/AutoCSV/public/csv/.", secure: true)

	      Dir.mkdir("C:/Sites/Rails/AutoCSV/public/csv")

	      @new_output = Output.create(:terminate => false)


	      s3 = AWS::S3.new
	      encoding_options = {
	        :invalid           => :replace,  # Replace invalid byte sequences
	        :undef             => :replace,  # Replace anything not defined in ASCII
	        :replace           => '',        # Use a blank for those replacements
	        :universal_newline => true       # Always break lines with \n
	      }
	      

	      i = 1 # set index counter
	      student_index = 0

	      load_id = SecureRandom.hex

	      failed_filename = "#{@new_output.id}_failed.csv"
	      output_filename = "#{@new_output.id}_output.csv"
	          File.open("public/#{output_filename}", "w") do |output| #initiate output CSV 
	            File.open("public/#{failed_filename}", "w") do |failed| #initiate failed CSV 

	              Dir.glob("J:/Diglab2010/Dbf/CSV/*.csv") do |fname|
	                  File.open("public/csv/#{@new_output.id}_#{i}_process_csv.csv", "w") do |new_file|
	                end
	                File.rename fname, "public/csv/#{@new_output.id}_#{i}_process_csv.csv" #move file to process into local folder

	                if i == 1 #set headers for first iteration

	                    @output = []
	                    @failed = []

	                        output <<  "url, student_id, accesscode, last_name, first_name, grade, folder, email, dob, teacher, school_id, package_id, shoob_id, rec_type, load_id"
	                        output << "\n"
	                        failed <<  "Reason, url, student_id, acesscode, last_name, first_name, grade, folder, email, dob, teacher, ca_code, rec_type, load_id"
	                        failed << "\n"

	                      end

	                        @csv = SmarterCSV.process("public/csv/#{@new_output.id}_#{i}_process_csv.csv", options={:file_encoding =>'iso-8859-1'}) do |chunk| #goes through file to upload images from local network
	                          chunk.each do |h|
	                            student_index = student_index + 1
	                            unless h["ca_code"].nil? 
					      			schools = School.where("ca_code like ?", "%#{h["ca_code"]}%")

						      		if schools.any?
						      			school = schools.last
						      			packages = school.packages.where("lower(slug) like ?", "%#{h["slug"].downcase}%")
						      			if packages.any? 
						      				package = packages.last
				                            unless h["url"].nil? || h["url"] == ""

				                              if File.exists?("#{h["url"]}.jpg")
				                                file_name = File.basename(h["url"])
				                                basename = file_name.downcase

				                                Auto.watermark_images(h["url"], h["folder"], basename, s3, student_index, i)
				                                @failed << false
				                                @output << true
				                                response = "#{basename}, #{h["student_id"]}, #{h["accesscode"]}, #{h["last_name"]}, #{h["first_name"]}, #{h["grade"]}, #{h["folder"]}, #{h["email"]}, #{h["dob"]}, #{h["teacher"]}, #{school.id}, #{package.id}, #{h["shoob_id"]}, #{h["rec_type"]}, #{load_id}".encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
				                                output << response.encode(Encoding.find('ASCII'), encoding_options)
				                                output << "\n"
				                                
				                              else #no image found on local server
				                                #write error file
				                                @failed << true
				                                @output << false
				                                response = "Unable to locate student image in local folder, #{h["url"]}, #{h["student_id"]}, #{h["acesscode"]}, #{h[last_name]}, #{h["first_name"]}, #{h["grade"]}, #{h["folder"]}, #{h["email"]}, #{h["dob"]}, #{h["teacher"]}, #{h["ca_code"]}, #{h["rec_type"]}, h#{load_id}"
				                                failed << response.encode(Encoding.find('ASCII'), encoding_options)
				                                failed << "\n"

				                                puts "Unable to locate student image #{student_index} of CSV #{i}."
				                              end #end if file exists
				                            else #url is blank, load empty kid


				                              puts "Student #{student_index} of CSV #{i} has no image. Adding to CSV."

				                              @failed << false
				                                @output << true
				                                response = ", #{h["student_id"]}, #{h["accesscode"]}, #{h["last_name"]}, #{h["first_name"]}, #{h["grade"]}, #{h["folder"]}, #{h["email"]}, #{h["dob"]}, #{h["teacher"]}, #{school.id}, #{package.id}, #{h["shoob_id"]}, #{h["rec_type"]}, #{h["load_id"]}".encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
				                                output << response.encode(Encoding.find('ASCII'), encoding_options)
				                                output << "\n"

				                            end #end unless
				                        else #if no packages found for school 
				                        	@failed << true
			                                @output << false
			                                response = "No package found with slug #{h["slug"]} for school with CA code #{["ca_code"]}, #{h["url"]}, #{h["student_id"]}, #{h["acesscode"]}, #{h[last_name]}, #{h["first_name"]}, #{h["grade"]}, #{h["folder"]}, #{h["email"]}, #{h["dob"]}, #{h["teacher"]}, #{h["ca_code"]}, #{h["rec_type"]}, #{load_id}"
			                                failed << response.encode(Encoding.find('ASCII'), encoding_options)
			                                failed << "\n"

				                        end
				                    else #if no school found with ca code
				                    	@failed << true
		                                @output << false
		                                response = "No school found with CA code #{["ca_code"]}, #{h["url"]}, #{h["student_id"]}, #{h["acesscode"]}, #{h[last_name]}, #{h["first_name"]}, #{h["grade"]}, #{h["folder"]}, #{h["email"]}, #{h["dob"]}, #{h["teacher"]}, #{h["ca_code"]}, #{h["rec_type"]}, #{load_id}"
		                                failed << response.encode(Encoding.find('ASCII'), encoding_options)
		                                failed << "\n"
				                    end
				                else #if no ca_code
				                	@failed << true
	                                @output << false
	                                response = "No CA code given, #{h["url"]}, #{h["student_id"]}, #{h["acesscode"]}, #{h[last_name]}, #{h["first_name"]}, #{h["grade"]}, #{h["folder"]}, #{h["email"]}, #{h["dob"]}, #{h["teacher"]}, #{h["ca_code"]}, #{h["rec_type"]}, #{load_id}"
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
	      if @failed.include? true
	        obj = s3.buckets['shoobphoto'].objects["AutoCSV/failed/#{failed_filename}"]
	        obj.write(File.read("public/#{failed_filename}"))
	      else
	        File.delete("public/#{failed_filename}")
	      end

	      if @output.include? true
	        obj = s3.buckets['shoobphoto'].objects["AutoCSV/output/#{output_filename}"]
	        obj.write(File.read("public/#{output_filename}"))
	      end  

	     Launchy.open("https:///www.shoobphoto.com/autos/start_auto")
	      end # end if any csv files exist
	     
	  end

	  def self.watermark_images(url, folder, basename, s3, student_index, i)
	  	img = Magick::Image.read("#{url}.jpg").first
        mark = Magick::Image.read("#{Rails.root}/public/watermark.png").first
        mark.background_color = "Transparent"
        watermark = mark.resize_to_fit(img.rows, img.columns.to_f)

        img2 = img.dissolve(watermark, 0.75, 1, Magick::CenterGravity)
        img2.write("#{Rails.root}/public/watermarks/#{basename}.jpg")

        img3 = img.resize_to_fit(28, 35)
        img3.write("#{Rails.root}/public/index/#{basename}.jpg")

        obj_watermark = s3.buckets['shoobphoto'].objects["images/processed_watermarks/#{folder}/#{basename}.jpg"] # no request made
        File.open("#{Rails.root}/public/watermarks/#{basename}.jpg", "rb") do |watermarked_image|
          obj_watermark.write(watermarked_image)
        end

        obj_index = s3.buckets['shoobphoto'].objects["images/processed_index/#{folder}/#{basename}.jpg"] # no request made
        File.open("#{Rails.root}/public/index/#{basename}.jpg", "rb") do |index_image|
          obj_index.write(index_image)
        end

        File.delete("#{Rails.root}/public/watermarks/#{basename}.jpg")
        File.delete("#{Rails.root}/public/index/#{basename}.jpg")

        puts "Watermarking and indexing images for student #{student_index} of CSV #{i}. Uploading to S3..."

        obj = s3.buckets['shoobphoto'].objects["images/#{folder}/#{basename}.jpg"] # no request made
        obj.write(File.open("#{url}.jpg")) #Writes image found to s3
	  end
end
