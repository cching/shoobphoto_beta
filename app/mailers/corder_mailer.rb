class CorderMailer < ActionMailer::Base
  helper :application
  
  def receipt args
    @order = args
    @cart = Cart.find(@order.cart_id)


    mail :to => args[:email], :from => 'info@shoobphoto.com', :subject => 'Shoob Photography Order Receipt'
  end

  def send_receipt args
    @order = args
    @cart = Cart.find(@order.cart_id)


    mail :to => 'projects@shoobphoto.com', :from => 'info@shoobphoto.com', :subject => 'Shoob Photography Order Receipt'
  end
end