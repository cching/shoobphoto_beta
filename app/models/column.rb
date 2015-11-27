class Column < ActiveRecord::Base
	has_many :template_columns
  	has_many :templates, through: :template_columns
  	has_many :fields
end
