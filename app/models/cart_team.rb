class CartTeam < ActiveRecord::Base
	belongs_to :cart
	belongs_to :team
end
