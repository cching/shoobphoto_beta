class ExportMailer < ActionMailer::Base
  helper :application
  
  def send_mail args
    @export = args
    bucket = AWS::S3::Bucket.new('shoobphoto') 
    s3object = AWS::S3::S3Object.new(bucket, "csvs/#{@export.file_path}") 
    @image_url = s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true) 
    attachments["#{@export.file_path}.csv"] = open("#{@image_url}").read


    mail(:to => "awards@shoobphoto.com", :from => 'info@shoobphoto.com', :subject => 'Shoob Photography Award List',
     :cc => "#{@export.user.email}" )
  end

end