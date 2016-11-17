class StudentImage < ActiveRecord::Base
	belongs_to :student
	belongs_to :package

  has_many :senior_images

	has_attached_file :image,
  	:url => ':s3_domain_url',
  	:path => '/images/:folder/:filename.jpg',
                     :preserve_files => true
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/


  	has_attached_file :index,
  	:url => ':s3_domain_url',
  	:path => "/images/:folder/:filename.jpg",
                     :preserve_files => true
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

    has_attached_file :watermark,
    :processors => [:watermark],
                    :styles => { 
                                 :thumb => '150x150>', 
                                 :original => "800>",
                                 :watermark => { :geometry => '800>', :watermark_path => "#{Rails.root}/public/images/watermark.png" } 
                               },
                    :url => ':s3_domain_url',
                    :path => "/images/watermarks/:id/:style/:url.jpg",
                    :default_url => "https://shoobphoto.s3.amazonaws.com/images/package_types/:package_id/:package_image_file_name",
                     :preserve_files => true 
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

    def self.package_name(id)
      folder = StudentImage.find(id).folder
      name = folder.match(/([A-Za-z]+)(\d+)/)
      @out = "#{name[1].humanize} #{name[2]} Portraits"

      return @out  
 
    end
end 