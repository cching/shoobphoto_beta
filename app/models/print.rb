class Print < ActiveRecord::Base
	has_many :project_prints
	has_many :projects, through: :project_prints

	validates :name, :price, :presence => true
end
