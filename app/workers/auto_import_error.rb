class AutoImportScan
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk, s3_key, auto)
   		@auto = Auto.find(auto) 
   		bucket = AWS::S3::Bucket.new('shoobphoto')
      	s3 = AWS::S3.new
      	objects = bucket.objects.with_prefix('AutoCSV/scan').collect(&:key).drop(1)
	    objects.each do |object|
	      csv_path  = "https://s3-us-west-1.amazonaws.com/shoobphoto/#{object}"
	      csv_file  = open(csv_path,'r')
	      chunk = SmarterCSV.process(csv_file, {:file_encoding =>'iso-8859-1'}) do |chunk|
	      	chunk.each do |h|
	      		orderpackage = OrderPackage.find(h[:order_package_id])
	      		orderpackage.update(:scanned => h[:scanned], :qualified => h[:qualified])
	      	end
	      end
	  	end
 	end #end def
end #end class


  