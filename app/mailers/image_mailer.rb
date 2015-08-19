class ImageMailer < ActionMailer::Base
  helper :application
  
  def send_image args, email, prompt
    @images = args
    @email = email
    @prompt = prompt
    mail :to => @email, :from => 'info@shoobphoto.com', :subject => 'Shoob Photography Portraits'
  end
end