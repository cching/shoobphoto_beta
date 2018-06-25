class Dproject < ActiveRecord::Base
	belongs_to :dschool, foreign_key: 'scode'
	belongs_to :school, foreign_key: 'scode', :touch => true

	scope :by_school, -> {joins(:school).reorder('school.name')}

	has_attached_file :attachment,
  	:styles => { :medium => "300x300>", :thumb => "100x100>" },
  	:url => ':s3_domain_url',
  	:path => '/images/banners_front/:id/:style/:filename'
  	validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/

	def previous_dproject
  		Dproject.where(["id < ?", id]).last
	end

	def next_dproject
  		Dproject.where(["id > ?", id]).first
	end
end
