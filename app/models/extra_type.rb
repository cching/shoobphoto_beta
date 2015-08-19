class ExtraType < ActiveRecord::Base
	has_many :extras, :dependent => :destroy

	has_many :extra_assignments, dependent: :destroy
	has_many :options, through: :extra_assignments


	accepts_nested_attributes_for :options
	accepts_nested_attributes_for :extras
end
