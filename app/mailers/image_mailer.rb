class ImageMailer < ActionMailer::Base
  helper :application
  
  def send_image op, image
    @order_package = op
    @image = image
    mail :to => @order_package.cart.email, :from => 'info@shoobphoto.com', :subject => 'Shoob Photography Digital Images'
    op.update(:email_sent => true)
  end
end 