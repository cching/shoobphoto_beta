class Dproject < ActiveRecord::Base
	has_paper_trail on: [:update], only: [:status]
	has_many :dattachments
	belongs_to :school
	
	before_save :set_status_date
    before_save :update_change_log

	def sequential_dproject(q, direction)
		ordered_dprojects = Dproject.where.not(status:'Delivered').ransack(q)
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
