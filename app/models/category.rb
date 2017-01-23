class Category < ActiveRecord::Base
	has_many :subcategories
	has_many :items, through: :subcategories
	accepts_nested_attributes_for :subcategories, :allow_destroy => true
end
