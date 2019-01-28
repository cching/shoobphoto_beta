class Djob < ActiveRecord::Base
	has_many :dattachments
	belongs_to :school
	
	validates :school_id, numericality: { other_than: 999, :message => "cannot be blank" }

	scope :by_school, -> {joins(:school).reorder('schools.name')}

	#A class method import, with file passed through as an argument
	def self.import(file)
		#A block that runs through a loop in our CSV data
		CSV.foreach(file.path, headers: true) do |row|
			#Creates a user for each row in the CSV file	
			Djob.create! row.to_hash
		end
	end

	def self.to_csv
		CSV.generate do |csv|
			csv << ["School", "Scode", "Date", "Prin_name", "Prin1_email", "Sec_Name", "Sec1_Email"]
			all.each do |djob|
				csv << [djob.school.dname, djob.SCODE, djob.DATE, djob.school.principal, djob.school.prin_email, djob.school.secretary, djob.school.sec1_email, djob.TRIGS]
			end 
		end 
	end 

	def prev_djob
		Djob.where(["id < ?", id]).order(:id).last
  end

  def next_djob
		Djob.where(["id > ?", id]).order(:id).first
  end
  #(q)=params
  def sequential_djob(q, direction)
	ordered_djobs = Djob.ransack(q)
	djobs = ordered_djobs.result.includes(:school)
	
	index = djobs.index self
	next_index = index + direction

	return false if next_index < 0 || djobs.length < next_index

	djobs[next_index]
  end

end
