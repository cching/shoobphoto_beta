class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)
  		@user_id = []

      	chunk.each do |h|

          award = Award.where("lower(image_file_name) like ?", "%#{h["new_label"].downcase}%")

          if award.any?
            award = award.last
            if h["awd_date"] == "T"
              award.update(:add_date => true)
            else
              award.update(:add_date => false)
            end

            if h["awd_for"] == "T"
              award.update(:add_awarded_for => true)
            else
              award.update(:add_awarded_for => false)
            end

            if h["awd_def"] == "T"
              award.update(:add_definition => true)
            else
              award.update(:add_definition => false)
            end

            if h["time_per"] == "T"
              award.update(:add_period => true)
            else
              award.update(:add_period => false)
            end


     	end #end chunk
 
 	end
end

