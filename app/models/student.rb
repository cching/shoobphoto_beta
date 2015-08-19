class Student < ActiveRecord::Base
	has_many :cart_students, dependent: :destroy
  has_many :carts, through: :cart_students
  has_many :order_packages
 	belongs_to :school

  has_many :orders

 	has_many :student_images

 def self.import(file)
  	CSV.foreach(file.path, headers: true) do |row|
    id = Student.last.id + 1
    school = School.find_by_name(row['school'].split.map(&:capitalize).join(' '))
    student = school.students.new(:id => id)
    student.attributes = row.to_hash.slice(*["id", "district_id", "student_id", "last_name", "first_name", "grade", "email"])
    student.save!
    end
  end

  Elementary = [
    ['Kindergarten', 0],
    ['First Grade', 1],
    ['Second Grade', 2],
    ['Third Grade', 3],
    ['Fourth Grade', 4],
    ['Fifth Grade', 5],
    ['Sixth Grade', 6]
  ]

  Middle = [
    ['Sixth Grade', 6],
    ['Seventh Grade', 7],
    ['Eight Grade', 8]
  ]

  High = [
    ['Freshman', 9],
    ['Sophomore', 10],
    ['Junior', 11],
    ['Senior', 12]
  ]

    Grades = [
    ['Kindergarten', 0],
    ['First Grade', 1],
    ['Second Grade', 2],
    ['Third Grade', 3],
    ['Fourth Grade', 4],
    ['Fifth Grade', 5],
    ['Sixth Grade', 6],
    ['Seventh Grade', 7],
    ['Eight Grade', 8],
    ['Freshman', 9],
    ['Sophomore', 10],
    ['Junior', 11],
    ['Senior', 12]
  ]


end
