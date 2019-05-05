class StudentImage < ActiveRecord::Base
	belongs_to :student
	belongs_to :package

  has_many :senior_images

  has_many :order_packages

  has_many :download_images

	has_attached_file :image,
    styles: { original: "" },
    :convert_options => { :all => '-auto-orient' },   
  	:url => ':s3_domain_url',
  	:path => '/images/:folder/:filename:file_type',
                     :preserve_files => true
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/


  	has_attached_file :index,
  	:url => ':s3_domain_url',
  	:path => "/images/:folder/:filename:file_type",
                     :preserve_files => true
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

    has_attached_file :watermark,
                    :url => ':s3_domain_url',
                    :s3_headers =>  { "Content-Type" => "image/png" },
                    :path => "/images/watermarks/:id/watermark/:url:file_type",
                    :default_url => "https://shoobphoto.s3.amazonaws.com/images/package_types/:package_id/:package_image_file_name",
                     :preserve_files => true 
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

    before_post_process :rename_image

    def self.package_name(id)
      folder = StudentImage.find(id).folder
      name = folder.match(/([A-Za-z]+)(\d+)/)
      @out = "#{name[1].humanize} #{name[2].humanize} Portraits"
      if "#{name[1]}".include? "fall"
        downloadYear = "#{name[2]}"
        downloadYears = downloadYear.to_i
        @out = "#{name[1].humanize} #{downloadYears-1} Portraits"
      end
      return @out  
 
    end

    def rename_image
      extension = File.extname(image_file_name).downcase
      self.image.instance_write :file_name, "#{Time.now.to_i.to_s}"
    end

    
end 