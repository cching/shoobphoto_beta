class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)
  		@user_id = []

      	chunk.each do |h|

          school = School.where(:scode => h["scode"].to_i)
          schools = School.where("ca_code like ?", "%#{nscode}%")

          if school.any?
            school = school.last
            teacher = school.teachers.create(:name => "#{h["comptea"]}", :full_name => "#{h["comptea"]}", :teacher_id => h["cl_id"].to_i, :email => "#{h["email"]}")
          elsif schools.count == 1
            schools = schools.last
            teacher = school.teachers.create(:name => "#{h["comptea"]}", :full_name => "#{h["comptea"]}", :teacher_id => h["cl_id"].to_i, :email => "#{h["email"]}")
            schools.update(:scode => h["scode"].to_i)
          else
            school.teachers.create(:name => "#{h["comptea"]}", :full_name => "#{h["comptea"]}", :teacher_id => h["cl_id"].to_i, :email => "#{h["email"]}", :scode => h["scode"].to_i)
          end


     	end #end chunk
 
 	end
end

