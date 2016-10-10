class StartAuto
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)
  	bucket = AWS::S3::Bucket.new('shoobphoto')
    objects = bucket.objects.with_prefix('AutoCSV/import').collect(&:key).drop(1)

    objects.each do |object|
      csv_path  = "https://s3-us-west-1.amazonaws.com/shoobphoto/#{object}"

      csv_file  = open(csv_path,'r')

      chunk = SmarterCSV.process(csv_file, {:chunk_size => 1000}) do |chunk|
        PackageImport.perform_async(chunk)
      end
 
    end
  	end
  end