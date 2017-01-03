class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)
  		@user_id = []

      	chunk.each do |h|
      		school = School.where(:ca_code => "#{h["nscode"]}")
      		query = School.where("lower(name) like ?", "%#{h["school"].downcase[0..6]}%")

      		if school.any?
      			school = school.last
      			school.update(:scode => h["scode"].to_i)
      		elsif query.count == 1
      			query = query.last
      			query.update(:scode => h["scode"].to_i)
      		else
      			@user_id << "#{h["nscode"]}"
      		end
	   
     	end #end chunk
     	puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
      	puts @user_id
      	puts "#{@user_id.count}"
 	end
end

