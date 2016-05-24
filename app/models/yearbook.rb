class Yearbook < ActiveRecord::Base
	belongs_to :student
	belongs_to :user

	Payment = [
    ['Cash', 'cash'],
    ['Check', 'check'],
    ['Credit Card', 'credit card']
  ]

  def self.to_csv(yearbooks, students, looped)
  	@yearbooks = yearbooks
  	@students = students
  	@looped = looped
  	csv_file = ''

    csv_file << CSV.generate_line(['Student'] + ['Grade'] + ['Teacher'] + ['Date'] + ['Quantity'] + ['Price'] + ['Payment Type']  + ['Notes'])


    unless @students.nil? 
     	@students.each_with_index do |student, i| 
      		student.carts.where(:purchased => true).each do |cart| 
            unless @looped.include? student.id 
            cart.order_packages.where(:package_id => 7).where(:student_id => student.id).each do |o| 
              
            	csv_file << CSV.generate_line(["#{student.first_name student.last_name}"] + ["#{student.grade}"] + ["#{student.teacher}"] + ["$#{cart.created_at.strftime("%B %d, %Y")}"] + ["1"] + ["#{o.option.price(student.school)}"] + ["Shoob Online"] + [""])

               	@looped << student.id
            end
            end 
      		end
      end
 	end

 	unless @yearbooks.nil? 
     	@yearbooks.each do |yearbook| 
		   csv << ["#{yearbook.student.first_name yearbook.student.last_name }", yearbook.student.grade,  yearbook.student.teacher, yearbook.created_at.strftime("%B %d, %Y"), yearbook.quantity, yearbook.amount,  yearbook.payment_type, yearbook.try(:notes)]	
		   csv_file << CSV.generate_line(["#{yearbook.student.first_name yearbook.student.last_name}"] + ["#{yearbook.student.grade}"] + ["#{yearbook.student.teacher}"] + ["$#{yearbook.created_at.strftime("%B %d, %Y")}"] + ["#{yearbook.quantity}"] + ["#{yearbook.amount}"] + ["yearbook.payment_type"] + ["Shoob Online"] + ["#{yearbook.notes}"])
      end
 	end

    
  end
end
