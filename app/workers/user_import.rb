class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)
  		@user_id = []

      	chunk.each do |h|

 	            school = School.find_by_ca_code(h["ca_code"].to_s)
	            unless school.nil?
	           		school.users.create(:email => h["email"], :password => h["password"], :password_confirmation => h["password_confirmation"], :first_name => h["firstname"], :last_name => h["lastname"], :school_admin => h["administrator"], :principal => h["principal"], :secretary => h["secretary"], :teacher => h["teacher"], :parent => h["parent"])
	           	else
	           		@user_id << h["id"]
	        	end #end if
	          	
	        
     	end #end chunk
 	end
end

