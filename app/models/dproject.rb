class Dproject < ActiveRecord::Base
	has_many :dattachments
	belongs_to :school

	validates :school_id, numericality: { other_than: 999, :invalid_project => "School must be valid" } 

	scope :by_school, -> {joins(:school).reorder('schools.name')}

	has_attached_file :dfile,
  	:url => ':s3_domain_url',
  	:path => '/images/projects/:id/:filename'
  	do_not_validate_attachment_file_type :dfile

	def previous_dproject
  		Dproject.where(["id < ?", id]).last
	end

	def next_dproject
  		Dproject.where(["id > ?", id]).first
	end
end
