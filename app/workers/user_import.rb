class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)
  		@user_id = []

      	chunk.each do |h|
      		school = School.where(:scode => h["scode"].to_i)

      		if school.any?
      			school = school.last
      			if "#{h["awd_date"]}" == "T"
      				awd_date = true
      			else
      				awd_date = false
      			end

      			if "#{h["time_per"]}" == "T"
      				time_per = true
      			else
      				time_per = false
      			end
      			school.awards.create(:abbreviation => "#{h["abbreviation"]}", :image_file_name => "#{h["new_label"]}.jpg", :title => "#{h["award"]}", :add_period => time_per, :add_date => awd_date)

      		else
      			@user_id << h["scode"]
      		end


     	end #end chunk
     	puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
      	puts @user_id
      	puts "#{@user_id.count}"
 	end
end

