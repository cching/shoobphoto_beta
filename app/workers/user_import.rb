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

          school = School.where(:scode => h["scode"].to_i)
          schools = School.where("ca_code like ?", "%#{h["nscode"]}%")

          if school.any?
            school = school.last
            teacher = school.teachers.create(:name => "#{h["comptea"].encode(Encoding.find('ASCII'), encoding_options)}", :full_name => "#{h["comptea"].encode(Encoding.find('ASCII'), encoding_options)}", :teacher_id => h["cl_id"].to_i, :email => "#{h["email"].encode(Encoding.find('ASCII'), encoding_options)}")
          elsif schools.count == 1
            schools = schools.last
            teacher = school.teachers.create(:name => "#{h["comptea"].encode(Encoding.find('ASCII'), encoding_options)}", :full_name => "#{h["comptea"].encode(Encoding.find('ASCII'), encoding_options)}", :teacher_id => h["cl_id"].to_i, :email => "#{h["email"].encode(Encoding.find('ASCII'), encoding_options)}")
            schools.update(:scode => h["scode"].to_i)
          else
            school.teachers.create(:name => "#{h["comptea"].encode(Encoding.find('ASCII'), encoding_options)}", :full_name => "#{h["comptea"].encode(Encoding.find('ASCII'), encoding_options)}", :teacher_id => h["cl_id"].to_i, :email => "#{h["email"].encode(Encoding.find('ASCII'), encoding_options)}", :scode => h["scode"].to_i)
          end


     	end #end chunk
 
 	end
end

