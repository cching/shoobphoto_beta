class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)
  		@user_id = []

      	chunk.each do |h|

          school = School.where(:scode => h["scode"].to_i)

          if school.any?
            school = school.last
            teacher = school.teachers.create(:name => "#{h["teacher"]}", :grade => "#{h["grade"]}")
            students = school.students.where("lower_teacher like ?", "%#{teacher.name.downcase.gsub(/[^\w\s\d]/, '')}%")
            students.update_all(:teacher_id => teacher.id)
          else
            Teacher.create(:name => "#{h["teacher"]}", :grade => "#{h["grade"]}", :scode => h["scode"].to_i)
          end


     	end #end chunk
 
 	end
end

