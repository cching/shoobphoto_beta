class PackageImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk, package_id, school_id)
    	package = Package.find(package_id) 
   		school = School.find(school_id)
      	chunk.each do |h|
	        unless h["student_id"].nil?
	        student = school.students.find_by_student_id("#{h["student_id"]}")
	        s_id = StudentImage.last.id + 1

	          unless student.present?     
	            id = Student.last.id + 1
	            student = school.students.new(:id => id, :student_id => h["student_id"], :last_name => h["last_name"], :first_name => h["first_name"], :grade => h["grade"], :email => h["email"])
	            student.save
	           else
	           	student.update(:student_id => h["student_id"], :last_name => h["last_name"], :first_name => h["first_name"], :grade => h["grade"], :email => h["email"])
	          end

	          image = package.student_images.new(:id => s_id, :student_id => student.id, :image_file_name => h["url"], :folder => h["folder"], :grade => h["grade"], :index_file_name => "#{h[url]}-index")
	          image.save

	        end
     	end
 	end
end