class YearbookCache
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(school_id)
  		@school = School.find(school_id)
  		@students = []
  		@yearbooks = []

  		@school.students.each do |student|
	      if student.yearbooks.any?
	        student.yearbooks.each do |yearbook|
	          @yearbooks << yearbook
	        end 
	      end
	      if student.carts.any?
	        student.carts.each do |cart|
	          if cart.purchased?
	            cart.order_packages.each do |order|
	              if order.package_id == 7
	                @students << student
	              end
	            end
	          end
	        end
	      end
	    end
	    @students = @students.uniq
	    @yearbooks = @yearbooks.uniq
	   	@school.update(:student_ids => @students.map(&:inspect).join(', '))
	   	@school.update(:yearbook_ids => @students.map(&:inspect).join(', '))
 	end
end

