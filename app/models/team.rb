class Team < ActiveRecord::Base
	has_many :cart_teams, dependent: :destroy
	has_many :carts, through: :cart_teams
end
