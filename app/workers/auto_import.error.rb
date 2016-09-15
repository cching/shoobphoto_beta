class AutoImportError
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk, s3_key, auto)
   		@auto = Auto.find(auto) 
   		bucket = AWS::S3::Bucket.new('shoobphoto')
      	s3 = AWS::S3.new
      	chunk.each do |h|
      		@auto.student_errors.create(:priority => 10, :error_text => "#{h}", :error_description => "Couldn't locate student image on the computer - #{h["url"]}")


     	end #end chunk loop


 	end #end def
end #end class


 