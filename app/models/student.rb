class Student < ActiveRecord::Base
	has_many :cart_students, dependent: :destroy
  has_many :carts, through: :cart_students
  has_many :order_packages
 	belongs_to :school

  has_many :export_data_students
  has_many :export_datas, through: :export_data_students, dependent: :destroy

  has_many :orders

 	has_many :student_images

  belongs_to :period

  has_many :user_students
  has_many :users, through: :user_students

  has_many :yearbooks
  has_many :download_images

  has_many :export_list_students
  has_many :export_lists, through: :export_list_students

  has_attached_file :image, path: '/id_images/:filename',
  :s3_host_name => 's3-us-west-1.amazonaws.com',
                     :preserve_files => true

  validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/], region: 'us-west-1'

  accepts_nested_attributes_for :student_images, allow_destroy: true

 def self.import(chunk)
  chunk.each do |h|
    Field.create(:id => h[:id], :x => h[:x], :y => h[:y], :width => h[:width], :height => [:height], :align => "#{h[:align]}", :column => "#{h[:column]}", :template_id => h[:template_id], :font_id => h[:font_id], :text_size => h[:text_size], :color => "#{h[:color]}", :spacing => h[:spacing], :name => "#{h[:name]}", :created_at => "#{h[:created_at]}", :updated_at => "#{h[:updated_at]}")
  end
end

  def self.searching(school_id, first_name, last_name, grade, teacher, student_id)
  school = School.find(school_id)
  unless first_name.nil? || last_name.nil? || grade.nil? || teacher.nil?
    
    students = school.students.where(:id_only => true)

    students = students.where("lower(first_name) like ?", "%#{first_name.downcase}%") unless first_name.nil?
    students = students.where("lower(last_name) like ?", "%#{last_name.downcase}%") unless last_name.nil?
    students = students.where("grade = ?", "#{grade}") unless grade.nil? || grade == ""
    students = students.where("teacher like ?", "%#{teacher}%") unless teacher.nil? || teacher == ""
    students = students.where("student_id like ?", "%#{student_id}")
    
  else
    students = school.students.where(:id_only => true)
  end
  return students.order(:last_name)
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

  Operations = [
    ['Print', 'print'],
    ['Download', 'download'],
    ['Email Awards List', 'awards']
  ]

def self.sort_options
    sorts.map { |option| [option.titleize, option] }
  end
  
  def self.default_columns
    @default_columns ||= column_names.reject do |column|
      case column; when 'created_at', 'updated_at', 'id', /^image.+/, /_id$/; true end
    end
  end
  
  # Which columns can be sorted on during export.

  
  # Which columns are available for templates.


  def self.template_column_options
    {
      'Student ID' => 'student_id',
      'First Name' => 'first_name',
      'Last Name' => 'last_name',
      'Grade' => 'grade',
      'Email' => 'email',
      'Date of Birth' => 'dob',
      'Teacher' => 'teacher',
      'Shoob ID' => 'shoob_id',
      'Grade with label' => 'grade_with_label',
      'Last Name First Name' => 'last_name_first_name',
      'First Name Last Name' => 'first_name_last_name',
      'Image if Present' => 'image_if_present',
      'Grade with Label' => 'grade_with_label',
      'School Mascot Image' => 'school_mascot_image',
      'School Name' => 'school_name',
      'Type' => 'type',
      'Barcode' => 'barcode',
      'Prompt' => 'prompt',
      'Data1' => 'data1',
      'Data2' => 'data2',
      'Data3' => 'data3',
      'Data4' => 'data4'}
  end


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
