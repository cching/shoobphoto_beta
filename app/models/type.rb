class Type < ActiveRecord::Base
  belongs_to :pdf
  has_one :template, through: :pdf
  

  has_many :school_templates
  has_many :schools, through: :school_templates
end
