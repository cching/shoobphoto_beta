class StartAuto
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)
  		bucket = AWS::S3::Bucket.new('shoobphoto')
s3 = AWS::S3.new
bucket1 = s3.buckets["shoobphoto"]

DownloadImage.where.not(image_file_name: nil).each do |image|
unless image.image_file_name.nil? || image.image_file_name == ""
if AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name.upcase}.jpg").exists?
image.update(:image_file_name => image.image_file_name.upcase)
obj1 = bucket.objects["images/#{image.folder}/#{image.image_file_name}.jpg"]
obj2 = bucket.objects["images/watermarks/download_images/#{image.id}/original/#{image.image_file_name}.jpg"]
obj1.copy_to(obj2)
image.update(:watermark_file_name => image.image_file_name)
image.watermark.reprocess!
elsif AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name.downcase}.jpg").exists?
image.update(:image_file_name => image.image_file_name.downcase)
obj1 = bucket.objects["images/#{image.folder}/#{image.image_file_name}.jpg"]
obj2 = bucket.objects["images/watermarks/download_images/#{image.id}/original/#{image.image_file_name}.jpg"]
obj1.copy_to(obj2)
image.update(:watermark_file_name => image.image_file_name)
image.watermark.reprocess!
end
end
end





  	
  	end
  end