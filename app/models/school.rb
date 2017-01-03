class School < ActiveRecord::Base
	has_many :students

	has_many :shippings

	has_many :orders

	has_many :awards

	has_many :school_packages, dependent: :destroy
	has_many :packages, through: :school_packages

	has_many :carts

	belongs_to :school_type

	has_many :users

  has_many :school_templates

  has_many :types, through: :school_templates

  has_many :periods

  has_many :export_lists

  belongs_to :district
	belongs_to :city
	has_many :notes

	accepts_nested_attributes_for :notes, allow_destroy: true

	has_attached_file :logo,
  	:url => ':s3_domain_url',
  	:path => '/images/logos/:scode.png'
  	validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

end
