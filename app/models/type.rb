class Type < ActiveRecord::Base
  belongs_to :pdf
  has_one :template, through: :pdf
  
  validates_presence_of :name, :pdf
end
