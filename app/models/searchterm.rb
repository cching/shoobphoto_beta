class Searchterm < ActiveRecord::Base
	has_many :searchterm_items
  has_many :items, through: :searchterm_items
end
