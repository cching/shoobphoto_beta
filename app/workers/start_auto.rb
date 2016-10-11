class StartAuto
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)
  	
 
    end
  	end
  end