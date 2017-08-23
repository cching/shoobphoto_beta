class Project < ActiveRecord::Base
	has_many :project_prints
	has_many :prints, through: :project_prints

	validates_presence_of :name, :email, :position, :school
	validates_format_of :email, :with => /@/
    validates_length_of :phone, :minimum => 7, :too_short => 'must be at least 7 numbers'

	accepts_nested_attributes_for :project_prints, allow_destroy: true
end
