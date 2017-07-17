namespace :auto_upload do
task :upload => [ :environment ] do
   Auto.upload
end
end