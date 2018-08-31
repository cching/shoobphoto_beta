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
    ['January 2019'], 
    ['February 2019'],
    ['March 2019'],
    ['April 2019'],
    ['May 2019'],
    ['June 2019'],
    ['August 2018'],
    ['September 2018'],
    ['October 2018'],
    ['November 2018'],
    ['December 2018'],
    ['First Quarter'],
    ['Second Quarter'],
    ['Third Quarter'],
    ['Fourth Quarter'],
    ['First Trimester 2018-2019'],
    ['Second Trimester 2018-2019'],
    ['Third Trimester 2018-2019'],
    ['First Semester 2018-2019'],
    ['Second Semester 2018-2019'],
    ['Entire 2018-2018 School Year'],
    ['Other'],
    ['None']
  ]

end
