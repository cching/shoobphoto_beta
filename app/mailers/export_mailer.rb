class ExportMailer < ActionMailer::Base
  helper :application
  
  def send_mail args
    @export = args
    bucket = AWS::S3::Bucket.new('shoobphoto') 
    s3object = AWS::S3::S3Object.new(bucket, "csvs/#{@export.file_path}") 
    s3object_setup = AWS::S3::S3Object.new(bucket, "csvs/#{@export.file_path}-setup") 
    @image_url = s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true) 
    @image_url_setup = s3object_setup.url_for(:read, :expires => 60.minutes, :use_ssl => true) 
    attachments["#{@export.file_path}.csv"] = open("#{@image_url}").read
    attachments["#{@export.file_path}-setup.csv"] = open("#{@image_url_setup}").read

    mail(:to => "#{@export.user.email}", :from => 'info@shoobphoto.com', :subject => "awards",
     :cc => "#{@export.user.email}" )
  end

end 