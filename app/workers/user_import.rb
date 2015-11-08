class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)

      	chunk.each do |h|

 	            school = School.find_by_ca_code(h["ca_code"].to_s)
	            unless school.nil?
	           	school.users.create(:email => h["email"], :password => h["password"], :password_confirmation => h["password_confirmation"])
	        end #end if
	          	
	        
     	end #end chunk
 	end
end