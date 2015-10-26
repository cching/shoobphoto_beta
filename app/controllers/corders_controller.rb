class CordersController < ApplicationController
  before_filter :authenticate_user!, only: [:index, :processed, :unprocessed]

  before_action :require_admin, only: [:index, :processed, :unprocessed]

  def new
    @cart = Cart.find_by_cart_id(params[:cart_id])

    if @cart.price > 0
      free = true
    else
      free = false
    end

    @order = Corder.new :price => @cart.price, :free => free

end

  def index 
    @corders = Corder.all.order(:processed)
  end

  def show
    @order = Corder.find(params[:id])

    respond_to :js
  end

  def processed
    @corder = Corder.find(params[:id])
    @corder.update(:processed => true)

    respond_to :js
  end

  def unprocessed
    @corder = Corder.find(params[:id])
    @corder.update(:processed => false)

    respond_to :js
  end

  def confirm
    @cart = Cart.find_by_cart_id(params[:cart_id])
    if @cart.price > 0
      free = true
    else
      free = false
    end
    @order = @cart.corders.new (order_params).merge(:price => @cart.price, :free => free)
      @order.ip_address = request.remote_ip 

    if @order.save
        @cart.purchased = true
        @cart.cart_type = "catalog"
        @cart.save
        CorderMailer.receipt(@order).deliver
        redirect_to root_path, notice: "Your order has been successfully placed! We've emailed you a copy of your receipt."
      else
        respond_to do |format|
        format.html { render 'new', :price => @order.price }
          format.json { render json: @order.errors, status: :unprocessable_entity }
          @order.errors.each do |order|
            puts "#{order}"
          end
          end 
      end

  end


    def require_admin
      unless current_user.try(:admin)
        redirect_to root_path
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:corder).permit(:cart_id, :last_name, :first_name, :ip_address, :phone, :posted, :email, :price, :notes, :address, :city, :state, :zip_code, :card_type, :card_expires_on, :card_number, :card_verification, :shipping_state, :processed, :shipping_address, :shipping_zip, :shipping_city, :student_id, :school_id)
    end

end

