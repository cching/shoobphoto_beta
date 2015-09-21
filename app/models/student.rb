class Student < ActiveRecord::Base
	has_many :cart_students, dependent: :destroy
  has_many :carts, through: :cart_students
  has_many :order_packages
 	belongs_to :school

  has_many :export_data_students
  has_many :export_datas, through: :export_data_students, dependent: :destroy

  has_many :orders

 	has_many :student_images

  has_attached_file :image, path: '/id_images/:filename',
  :s3_host_name => 's3-us-west-1.amazonaws.com'

  validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/], region: 'us-west-1'

  accepts_nested_attributes_for :student_images, allow_destroy: true

 def self.import(file)
  	CSV.foreach(file.path, headers: true) do |row|
    id = Student.last.id + 1
    school = School.find_by_name(row['school'].split.map(&:capitalize).join(' '))
    student = school.students.new(:id => id)
    student.attributes = row.to_hash.slice(*["id", "district_id", "student_id", "last_name", "first_name", "grade", "email"])
    student.save!
    end
  end


    Grades = [
    ['Preschool', 'PS'],
    ['Kindergarten', 'K'],
    ['First Grade', 1],
    ['Second Grade', 2],
    ['Third Grade', 3],
    ['Fourth Grade', 4],
    ['Fifth Grade', 5],
    ['Sixth Grade', 6],
    ['Seventh Grade', 7],
    ['Eighth Grade', 8],
    ['Freshman', 9],
    ['Sophomore', 10],
    ['Junior', 11],
    ['Senior', 12]
  ]

def name
    "#{last_name}, #{first_name}"
  end
  
  # Called by formtastic.
  def to_label
    "#{student_id} #{name}"
  end
  
  # Column for print jobs.
  def last_name_first_name
    "#{last_name}, #{first_name}"
  end

  # Column for print jobs.
  def first_name_last_name
    "#{first_name} #{last_name}"
  end

  # Column for print jobs.
  def school_name
    school.name
  end
  
  # Column for print jobs.
  def school_mascot_image
    school.mascot_image
  end
  
  # Column for print jobs.
  def bus_stop_name
    bus_stop.try(:name)
  end
  
  # Column for print jobs.
  def bus_route_name
    bus_route.try(:name)
  end
  
  # Column for print jobs.
  def bus_route_color_value
    bus_route.try(:color_value)
  end
  
  # Column for print jobs.
  def barcode
    "*#{student_id}*"
  end

  def identifier
    student_id
  end
  
  # Column for print jobs.
  def grade_with_label
    "Grade: #{grade}"
  end
  
  # Column for print jobs.
  def image_if_present
    image? ? image : nil
  end

end
