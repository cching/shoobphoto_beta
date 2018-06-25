class Dproject < ActiveRecord::Base
	belongs_to :dschool, foreign_key: 'scode'
	belongs_to :school, foreign_key: 'scode', :touch => true

	# scope :by_school, -> {joins(:scode).reorder('school.dname')}

	has_attached_file :dfile,
  	# :styles => { :medium => "300x300>", :thumb => "100x100>" },
  	:url => ':s3_domain_url',
  	:path => '/images/projects/:id/:style/:filename'
  	do_not_validate_attachment_file_type :dfile

	def previous_dproject
  		Dproject.where(["id < ?", id]).last
	end

	def next_dproject
  		Dproject.where(["id > ?", id]).first
	end
end
