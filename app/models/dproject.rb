class Dproject < ActiveRecord::Base
	has_many :dattachments
	has_many :dprojecttests
	has_many :invoices, dependent: :destroy
	has_many :lineitems, through: :invoices	
	belongs_to :school
	
	accepts_nested_attributes_for :invoices
	accepts_nested_attributes_for :dattachments, allow_destroy: true
	accepts_nested_attributes_for :lineitems

	before_save :set_status_date
	before_save :update_change_log

	has_attached_file :testattachment,
  	:url => ':s3_domain_url',
  	:path => '/images/projects/:id/:updated_at/:filename'
	do_not_validate_attachment_file_type :testattachment
	  
	has_attached_file :afile,
    :url => ':s3_domain_url',
    :path => '/images/projects/:id/:updated_at/:filename'
    do_not_validate_attachment_file_type :afile

	def sequential_dproject(q, direction)
		ordered_dprojects = Dproject.ransack(q)
		dprojects = ordered_dprojects.result.includes(:school)
		
		index = dprojects.index self
		next_index = index + direction
	
		return false if next_index < 0 || dprojects.length < next_index
	
		dprojects[next_index]
	end
	

	def set_status_date
	  self.status_date = Time.now if status_changed?
	end

	def update_change_log
      self.change_log = self.change_log.to_s + "\n" + self.status.to_s + " " + self.status_date.try(:strftime, '%b %e, %Y').to_s if status_changed?
    end

	validates :school_id, numericality: { other_than: 999, :message => "cannot be blank" }
	validates_presence_of :assigned_to

	scope :by_school, -> {joins(:school).reorder('schools.name')}

	def previous_dproject
  		Dproject.where(["id < ?", id]).last
	end

	def next_dproject
  		Dproject.where(["id > ?", id]).first
	end
end