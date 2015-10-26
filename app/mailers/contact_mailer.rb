class ContactMailer < ActionMailer::Base
  helper :application
  
  def send_mail args
    @contact = args

    mail :to => 'cfching95@gmail.com', :from => 'info@shoobphoto.com', :subject => 'Shoob Photography Contact'
  end
end