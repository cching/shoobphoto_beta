class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"


  	def perform(chunk)
  		@user_id = []

      	chunk.each do |h|

          school = School.where(:scode => h["scode"].to_i)
          schools = School.where("ca_code like ?", "%#{h["nscode"].encode('UTF-8', :invalid => :replace, :undef => :replace)}%")

          if school.any?
            school = school.last
            teacher = school.teachers.create(:name => "#{h["teacher"].encode('UTF-8', :invalid => :replace, :undef => :replace)}", :full_name => "#{h["comptea"].encode('UTF-8', :invalid => :replace, :undef => :replace)}", :teacher_id => h["cl_id"].to_i, :email => "#{h["email"].encode('UTF-8', :invalid => :replace, :undef => :replace)}")
          elsif schools.count == 1
            schools = schools.last
            teacher = school.teachers.create(:name => "#{h["teacher"].encode('UTF-8', :invalid => :replace, :undef => :replace)}", :full_name => "#{h["comptea"].encode('UTF-8', :invalid => :replace, :undef => :replace)}", :teacher_id => h["cl_id"].to_i, :email => "#{h["email"].encode('UTF-8', :invalid => :replace, :undef => :replace)}")
            schools.update(:scode => h["scode"].to_i)
          else
            school.teachers.create(:name => "#{h["teacher"].encode('UTF-8', :invalid => :replace, :undef => :replace)}", :full_name => "#{h["comptea"].encode('UTF-8', :invalid => :replace, :undef => :replace)}", :teacher_id => h["cl_id"].to_i, :email => "#{h["email"].encode('UTF-8', :invalid => :replace, :undef => :replace)}", :scode => h["scode"].to_i)
          end


     	end #end chunk
 
 	end
end

