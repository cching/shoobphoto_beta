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
			csv << ["id", "school", "SCODE", "JOB", "JOBTYPE", "DATE", "STARTTIME", "TRIGS", "PRICELIST", "RIGS", "PHOTOG1", "PHOTOG_NOTE", "JOB_NOTES", "LAB_NOTE", "PACK_NOTES", "LOCATION", "PROJSALE", "SALE", "ESTSHOTS", "FLYERS", "NOTICES", "POSTERS", "NOTICE_NOTE", "CONF_CALL", "RECONFIRM_CALL", "DATA_CALL", "DATA_REC", "DATA_SETUP", "DATA2WEB", "LAPTOPS", "CROP_DATE", "CROP_NOTE", "TYPE_DATE", "TYPED_BY", "CORR_DATE", "CORR_BY", "DATA_CLEAN", "IMG2WEB", "PRINT_DATE", "PRINT_BY", "ID_SHIP", "PKS_SHIP", "PKS_NOTE", "MUG_SHIP", "CR_SHIP", "PICS4TEA", "CP_PROOF_PRINTED", "CP_PROOF_SHIPPED", "CP_NOTES", "CP_PROOF_RET", "CP_CORR", "CP_PRINTED", "CP_SHIP", "ADMIN_CD", "YB_UG_CD", "YB_SENR_CD", "PRIN_ALBUM", "TSHOTS", "TPKS", "ZPKS", "AVPK", "CONF_YN", "CONF", "created_at", "updated_at", "school_id", "status", "RECONF", "RECONFYN", "DATA_NOTES", "LAPTOP_NOTES", "LAPTOP_DLD"]
			all.each do |djob|
				csv << [djob.id, djob.school.dname, djob.SCODE, djob.JOB, djob.JOBTYPE, djob.DATE, djob.STARTTIME, djob.TRIGS, djob.PRICELIST, djob.RIGS, djob.PHOTOG1, djob.PHOTOG_NOTE, djob.JOB_NOTES, djob.LAB_NOTE, djob.PACK_NOTES, djob.LOCATION, djob.PROJSALE, djob.SALE, djob.ESTSHOTS, djob.FLYERS, djob.NOTICES, djob.POSTERS, djob.NOTICE_NOTE, djob.CONF_CALL, djob.RECONFIRM_CALL, djob.DATA_CALL, djob.DATA_REC, djob.DATA_SETUP, djob.DATA2WEB, djob.LAPTOPS, djob.CROP_DATE, djob.CROP_NOTE, djob.TYPE_DATE, djob.TYPED_BY, djob.CORR_DATE, djob.CORR_BY, djob.DATA_CLEAN, djob.IMG2WEB, djob.PRINT_DATE, djob.PRINT_BY, djob.ID_SHIP, djob.PKS_SHIP, djob.PKS_NOTE, djob.MUG_SHIP, djob.CR_SHIP, djob.PICS4TEA, djob.CP_PROOF_PRINTED, djob.CP_PROOF_SHIPPED, djob.CP_NOTES, djob.CP_PROOF_RET, djob.CP_CORR, djob.CP_PRINTED, djob.CP_SHIP, djob.ADMIN_CD, djob.YB_UG_CD, djob.YB_SENR_CD, djob.PRIN_ALBUM, djob.TSHOTS, djob.TPKS, djob.ZPKS, djob.AVPK, djob.CONF_YN, djob.CONF, djob.created_at, djob.updated_at, djob.school_id, djob.status, djob.RECONF, djob.RECONFYN, djob.DATA_NOTES, djob.LAPTOP_NOTES, djob.LAPTOP_DLD]
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
