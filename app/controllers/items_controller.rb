class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @cart = Cart.create(:cart_type => "catalog", :cart_id => (0...8).map { (65 + rand(26)).chr }.join)

    redirect_to items_cart_path(@cart.cart_id)
  end

  def filter
    @cart = Cart.find(params[:cart])
    @subcat = Subcategory.find(params[:subcat])

    @items = @subcat.items

  end

  def search
    @cart = Cart.find(params[:cart])
    
    @sterm = Searchterm.where("name like ?", "%#{params[:find]}%")

    if @sterm.any?
      puts "#{@sterm.pluck(:name)}"

      @items = @sterm.last.items
    else
      @items = Item.all.order(:number)
    end

  end

  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def preview
    @item = Item.find(params[:id])
    @cart = Cart.find(params[:cart])

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
    @item = Item.find(params[:id])
    @item.update(item_params)

    respond_to :js
  end

  def update_items
    @cart = Cart.find_by_cart_id(params[:cart_id])

    @cart.update(cart_params)

    @cart.price = 0

    @cart.items.each do |item|
      quantity = @cart.cart_items.where(:item_id => item.id).last.quantity
      @cart.price = @cart.price + (item.price*quantity)
    end

    @cart.save

    redirect_to new_corder_path(@cart.cart_id)
  end

  def cart
    @items = Item.all.order(:number)
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

    respond_to :js
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
      params.require(:item).permit(:name, :price, :item_id, :per_page, :category_ids => [])
    end

    def cart_params
      params.require(:cart).permit(:cart_type, cart_items_attributes: [:id, :quantity])
    end
end
