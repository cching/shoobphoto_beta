namespace :auto_upload do
	task :upload => [ :environment ] do
	   Auto.upload
	end

	task :scan => [ :environment ] do
	   Auto.check_orders
	end
end