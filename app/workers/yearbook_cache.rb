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
	          @yearbooks << yearbook.id
	        end 
	      end
	      if student.carts.any?
	        student.carts.each do |cart|
	          if cart.purchased?
	            cart.order_packages.each do |order|
	              if order.package_id == 7
	                @students << student.id
	              end
	            end
	          end
	        end
	      end
	    end
	    @students = @students.uniq
	    @yearbooks = @yearbooks.uniq
	   	@school.update(:student_cache => @students.map(&:inspect).join(', '))
	   	@school.update(:yearbook_cache => @yearbooks.map(&:inspect).join(', '))
 	end
end

