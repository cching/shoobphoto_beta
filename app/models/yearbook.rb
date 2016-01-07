class Yearbook < ActiveRecord::Base
	belongs_to :student

	Payment = [
    ['Cash', 'cash'],
    ['Check', 'check'],
    ['Credit Card', 'credit card']
  ]
end
