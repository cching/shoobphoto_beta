class EmailerImport
	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"
  	def perform(chunk, school_id, prompt)
   		school = School.find(school_id)
   		bucket = AWS::S3::Bucket.new('shoobphoto')
      	chunk.each do |h|
            student = school.students.find_by_student_id("#{h["student_id"]}")
            @image = []
            if AWS::S3::S3Object.new(bucket, "images/#{h["folder1"]}/#{h["url1"]}.jpg").exists?
                s3object = AWS::S3::S3Object.new(bucket, "images/#{h["folder1"]}/#{h["url1"]}.jpg")
                @image << s3object.url_for(:read, :expires => 300.days, :use_ssl => true)
            else
              @image << false
            end

            if AWS::S3::S3Object.new(bucket, "images/#{h["folder2"]}/#{h["url2"]}.jpg").exists?
                s3object = AWS::S3::S3Object.new(bucket, "images/#{h["folder2"]}/#{h["url2"]}.jpg")
                @image << s3object.url_for(:read, :expires => 300.days, :use_ssl => true)
            else
              @image << false
            end

            ImageMailer.send_image(@image, h["email"], prompt).deliver
          
      end
 	end
end