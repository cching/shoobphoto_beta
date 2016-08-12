class Award < ActiveRecord::Base
	belongs_to :export_list
	has_many :user_students
	has_many :export_list_students
end
