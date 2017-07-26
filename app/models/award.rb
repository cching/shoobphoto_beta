class Award < ActiveRecord::Base
	belongs_to :export_list
	has_many :user_students
	has_many :export_list_students
	belongs_to :school

	has_attached_file :image,
  	:url => ':s3_domain_url',
  	:path => '/images/awards/:image_file_name'
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  	validates_presence_of :image, :school_id

  	TimePeriods = [
    ['January 2018', 'january2018'], 
    ['February 2018', 'february2018'],
    ['March 2018', 'march2018'],
    ['April 2018', 'april2018'],
    ['May 2018', 'may2018'],
    ['June 2018', 'june2018'],
    ['August 2017', 'august2017'],
    ['September 2017', 'september2017'],
    ['October 2017', 'october2017'],
    ['November 2017', 'november2017'],
    ['December 2017', 'december2017'],
    ['First Trimester 2017-2018', 'first_trimester20172018'],
    ['Second Trimester 2017-2018', 'second_trimester20172018'],
    ['Third Trimester 2017-2018', 'third_trimester20172018'],
    ['First Semester 2017-2018', 'first_semester20172018'],
    ['Second Semester 2017-2018', 'first_semester20172018'],
    ['Entire 2017-2018 School Year', 'entire_2017_2018'],
    ['Other', 'other']
  ]

end
