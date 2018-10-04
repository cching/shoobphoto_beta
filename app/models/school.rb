class School < ActiveRecord::Base
	validates_uniqueness_of :name
	has_many :dprojects
	has_many :djobs
	has_many :students
	has_many :student_images, through: :students

	has_many :shippings

	has_many :orders

	has_many :awards 

	has_many :school_packages, dependent: :destroy
	has_many :packages, through: :school_packages

	has_many :carts

	belongs_to :school_type

	has_many :users
	has_many :educators

  has_many :school_templates

  has_many :types, through: :school_templates

  has_many :periods

  has_many :export_lists

  belongs_to :district
	belongs_to :city
	has_many :notes

	accepts_nested_attributes_for :notes, allow_destroy: true

	has_attached_file :logo,
  	:url => ':s3_domain_url',
  	:path => '/images/logos/:scode.png'
  	validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  	def dname
  		return name
  	end

  	def self.search(search)
  		where("name LIKE ?", "%#{search}%")
	end
	def self.import(file)
			#A block that runs through a loop in our CSV data
			CSV.foreach(file.path, headers: true, skip_blanks: true) do |row|
			#Creates a user for each row in the CSV file  
			  
					hashed_row = row.to_hash
					district_name = hashed_row.delete('district')
					city_name = hashed_row.delete('city')
					school_name = hashed_row.delete('name')
					district = District.find_by('name like ?', '%#{district_name}%')
					city = City.find_by('name like?', '%#{district_name}%')

					school = School.find_by('name like ?', '%#{school_name}%')

					found_school = if school.present?
					school.assign_attributes(hashed_row)
					school
					else
					school = School.create(hashed_row)
					school.update(name: school_name)
					school
					end
					found_school.update(district: district, city: city)
				end
		end
end
