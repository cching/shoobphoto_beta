class CordersController < ApplicationController
  before_filter :authenticate_user!, only: [:index, :processed, :unprocessed]

  before_action :require_admin, only: [:index, :processed, :unprocessed]

  def after_purchase_corder
    @cart = Cart.find_by_cart_id(params[:cart_id])
  end

  def new
    @cart = Cart.find_by_cart_id(params[:cart_id])

    if @cart.price > 0
      @free = true
    else
      @free = false
    end

    @order = Corder.new :price => @cart.price, :free => @free

end

def zip_code
  respond_to do |format|
    format.html
    format.mobile
  end
end

def create_cart
    @cart = Cart.create(:cart_type => "catalog", :cart_id => (0...8).map { (65 + rand(26)).chr }.join, :zip_code => params[:zip_code], :email => params[:email])

    redirect_to items_cart_path(@cart.cart_id)
  end

def import
  unless params[:file].nil?
    Corder.import(params[:file])
    redirect_to corders_path, notice: "Orders successfully imported."
  end
  end

def export
    export = Export.create
      CorderExport.perform_async(export.id)

      redirect_to corders_path, notice: "The new order CSV is currently being generated."
    end

  def index 
    @corders = Corder.all.order(:processed, :id)
  end

  def show
    @order = Corder.find(params[:id])

    respond_to :js
  end

  def processed
    @corder = Corder.find(params[:id])
    @corder.processed = true
    @corder.save validate: false
 
    puts @corder.errors.first

    respond_to :js
  end

  def unprocessed
    @corder = Corder.find(params[:id])
    @corder.processed = false
    @corder.save validate: false

   

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
        CorderMailer.send_receipt(@order).deliver
        redirect_to after_purchase_corder_path(@order.cart.cart_id)
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
      params.require(:corder).permit(:grade, :cart_id, :last_name, :first_name, :district, :ip_address, :schools, :school, :phone, :posted, :email, :price, :notes, :address, :city, :state, :zip_code, :card_type, :card_expires_on, :card_number, :card_verification, :shipping_state, :processed, :shipping_address, :shipping_zip, :shipping_city, :student_id, :school_id, :admin, :teacher, :parent)
    end

end

