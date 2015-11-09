class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)

      	chunk.each do |h|

      		district = District.where("name like ?", "%#{h["district"]}%")

      		if district.any?
      			district = district.last
      		else
      			district = district.create(:name => "#{h["district"]}")
      		end

      		city = City.where("name like ?", "%#{h["city"]}%")

      		if city.any?
      			city = city.last
      		else
      			city.create(:name => "#{h["city"]}")
      		end

      		district.school_notes.create(:cdscode => h["cdscode"], :name => "#{h["school"]}", :address => "#{h["address"]}", :phone => "#{h["phone"]}", :principal => "#{h["principal"]}", :secretary => "#{h["secretary"]}", :city_id => city.id)

 	            #school = School.find_by_ca_code(h["ca_code"].to_s)
	            #unless school.nil?
	           	#school.users.create(:email => h["email"], :password => h["password"], :password_confirmation => h["password_confirmation"])
	        #end #end if
	          	
	        
     	end #end chunk
 	end
end