class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @cart = Cart.create(:cart_type => "catalog", :cart_id => (0...8).map { (65 + rand(26)).chr }.join)

    redirect_to items_cart_path(@cart.cart_id)
  end

  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def new
    @item = Item.new
    respond_with(@item)
  end

  def quantity
    @cart = Cart.find_by_cart_id(params[:cart_id])
  end

  def edit
  end

  def update_items
    @cart = Cart.find_by_cart_id(params[:cart_id])

    @cart.update(cart_params)

    redirect_to new_order_path(@cart.cart_id)
  end

  def cart
    @items = Item.all
    @cart = Cart.find_by_cart_id(params[:cart_id])
    respond_with(@items)
  end

  def create
    @item = Item.new(item_params)
    @item.save
    respond_with(@item)
  end

  def update
    @item.update(item_params)
    respond_with(@item)
  end

  def destroy
    @item.destroy
    respond_with(@item)
  end

  def add
    @item = Item.find(params[:id])
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @item.cart_items.create(:cart_id => @cart.id)

    @price = @cart.items.map(&:price).inject(:+)

    respond_to do |format|
      format.js
    end
  end

  def remove  
    @item = Item.find(params[:id])
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @item.cart_items.where(:cart_id => @cart.id).destroy_all

    @price = @cart.items.map(&:price).inject(:+)
    
    respond_to do |format|
      format.js
    end
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :price, :item_id, :per_page)
    end

    def cart_params
      params.require(:cart).permit(:cart_type, cart_items_attributes: [:id, :quantity])
    end
end
