class Yearbook < ActiveRecord::Base
	belongs_to :student
	belongs_to :user

	Payment = [
    ['Cash', 'cash'],
    ['Check', 'check'],
    ['Credit Card', 'credit card']
  ]
end
