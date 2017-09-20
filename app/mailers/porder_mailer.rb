class PorderMailer < ActionMailer::Base
  helper :application
  
  def receipt args
    @order = args
    @project = @order.project


    mail :to => @project.email, :from => 'info@shoobphoto.com', :subject => 'Shoob Photography Project Order Receipt'
  end
end