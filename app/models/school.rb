class School < ActiveRecord::Base
	has_many :students

	has_many :shippings

	has_many :orders

	has_many :school_packages, dependent: :destroy
	has_many :packages, through: :school_packages

	has_many :carts

	belongs_to :school_type

	has_many :users

  has_many :school_templates

  has_many :types, through: :school_templates

  has_many :periods

  has_many :export_lists

end
