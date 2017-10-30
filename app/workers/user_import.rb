class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"
  encoding_options = {
  :invalid           => :replace,  # Replace invalid byte sequences
  :undef             => :replace,  # Replace anything not defined in ASCII
  :replace           => '',        # Use a blank for those replacements
  :universal_newline => true       # Always break lines with \n
}

  	def perform(chunk)
  		@user_id = []

      	chunk.each do |h|
          item = Item.find(h["id"])  
          schools = School.where(ca_code: "#{h["ca_code"]}")

          if schools.any?
            schools.update_all(scode: "#{h["scode"]}")

          end

     	end #end chunk

 	end
end

