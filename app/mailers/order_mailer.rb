class OrderMailer < ActionMailer::Base
  helper :application
  
  def receipt args
    @order = args
    @cart = Cart.find(@order.cart_id)

    @students = @cart.students
    @packages = @cart.packages.order(:id)

    mail :to => args[:email], :from => 'info@shoobphoto.com', :subject => 'Shoob Photography Order Receipt'
  end
end