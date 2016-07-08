class SeniorImage < ActiveRecord::Base
	belongs_to :student_image
	has_many :favorites
	has_many :sheets
  has_many :addon_sheets

	has_attached_file :image,
  	:url => ':s3_domain_url',
  	:path => '/images/:student_image_folder/:url.jpg',
                     :preserve_files => true

    has_attached_file :watermark,
    :processors => [:watermark],
                    :styles => { 
                                 :thumb => '150x150>', 
                                 :original => "800>",
                                 :watermark => { :geometry => '800>', :watermark_path => "#{Rails.root}/public/images/watermark.png" } 
                               },
                    :url => ':s3_domain_url',
                    :path => "/images/watermarks/seniors/:id/:style/:filename.jpg",
                     :preserve_files => true
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
