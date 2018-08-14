class Dproject < ActiveRecord::Base
	has_many :dattachments
	belongs_to :school
	
	before_save :set_status_date
    before_save :update_change_log


	def set_status_date
	  self.status_date = Time.now if status_changed?
	end

	def update_change_log
      self.change_log = self.change_log.to_s + " | " + self.status.to_s + " " + self.status_date.try(:strftime, '%b %e, %Y').to_s if status_changed?
    end

	validates :school_id, numericality: { other_than: 999, :message => "cannot be blank" }
	validates_presence_of :assigned_to

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
