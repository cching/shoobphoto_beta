class Font < ActiveRecord::Base
	has_many :fields
  
  has_attached_file :file, path: '/fonts/:id/:filename',
  :s3_host_name => 's3-us-west-1.amazonaws.com'
  
  validates_presence_of :name
  validates_attachment :file, presence: true 
  validates_attachment_file_name :file, :matches => [/ttf\Z/], region: 'us-west-1'
  
  before_destroy :ensure_no_fields
  
  private
  
  def ensure_no_fields
    if fields.any?
      errors.add :base, 'Cannot be deleted. There are fields that use this font.'
    end
    false
  end

end
