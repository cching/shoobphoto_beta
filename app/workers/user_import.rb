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

          school = School.where("ca_code like ?", "%#{h["ca_code"]}%")

          if school.any?
            school = school.last
            teacher = school.teachers.where(:teacher_id => h["tea_id"].to_i)

            if teacher.any?
              teacher = teacher.last
              students = school.students.where("student_id like ?", "%#{h["st_stu_id"]}%").where(:id_only => true)
              students_access = school.students.where("access_code like ?", "%#{h["accesscode"]}%").where(:id_only => true)
              if students.any?
                student = student.last
                student.update(:teacher_id => teacher.id)
              elsif students_access.any?
                student = students_access.last
                student.update(:teacher_id => teacher.id)
              end #end students found
                
            end #end teachers found
        else #else if no school found
          @user_id << h["ca_code"]
        end

     	end #end chunk
  puts "#{@user_id.count}"
        puts @user_id
 	end
end

