class TemplateColumn < ActiveRecord::Base
	belongs_to :template
	belongs_to :column
end
