class ProjectPrint < ActiveRecord::Base
	belongs_to :project
	belongs_to :print

	validates_presence_of :quantity

	has_attached_file :image

	has_attached_file :file
end
