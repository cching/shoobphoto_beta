class CartStudent < ActiveRecord::Base
	belongs_to :student
	belongs_to :cart
end
 