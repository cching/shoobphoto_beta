Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_protocol] = 'https'
Paperclip::Attachment.default_options[:s3_credentials] = 
  { :bucket => ENV['S3_BUCKET_NAME'],
    :access_key_id => ENV['ACCESS_KEY'],
    :secret_access_key => ENV['SECRET_KEY'] }


Paperclip.interpolates :folder do |attachment, style|
  attachment.instance.folder
end