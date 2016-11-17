class StartAuto
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)
		StudentImage.where(folder: "fall2017").where(watermark_file_name: nil).each do |image|
		image.update(:watermark_file_name => image.image_file_name)
		end  	
  	end
  end