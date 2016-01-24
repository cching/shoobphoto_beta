class ExportMailer < ActionMailer::Base
  helper :application
  
  def send_mail args, tkey
    @export = args
    @key = tkey
    bucket = AWS::S3::Bucket.new('shoobphoto') 
    s3object = AWS::S3::S3Object.new(bucket, "csvs/#{@export.file_path}") 
    @image_url = s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true) 
    attachments["#{@export.file_path}.csv"] = open("#{@image_url}").read
    s3object = AWS::S3::S3Object.new(bucket, "zips/#{@key}") 
    @url = s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true) 
    attachments["StudentImages.zip"] = open("#{@url}").read


    mail(:to => "cfching95@gmail.com", :from => 'info@shoobphoto.com', :subject => "#{@export.school.name} - awards",
     :cc => "#{@export.user.email}" )
  end

end