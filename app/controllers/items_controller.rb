class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :search_term]
  protect_from_forgery except: [:add, :preview, :show]
  respond_to :html

  def index
    @cart = Cart.create(:cart_type => "catalog", :cart_id => (0...8).map { (65 + rand(26)).chr }.join, :zip_code => params[:zip_code], :email => params[:email])

    redirect_to items_cart_path(@cart.cart_id)
  end


  def search_term
    if Searchterm.where("name like ?", "%#{params[:search_term]}%").any?
      @term = Searchterm.where("name like ?", "%#{params[:search_term]}%").last
    else
      @term = Searchterm.create(:name => params[:search_term])
    end
    @item.searchterms << @term
    respond_to :js
  end

  def outside
    @cart = Cart.create(:cart_type => "catalog", :cart_id => (0...8).map { (65 + rand(26)).chr }.join)

    redirect_to items_cart_outside_path(@cart.cart_id, params[:cat])
  end

  

  def cart_outside
    @category = Category.find(params[:cat])
    @items = @category.items.order(:number)
    @cart = Cart.find_by_cart_id(params[:cart_id])
    respond_with(@items)
  end

  def all
    @cart = Cart.find(params[:cart])
    @items = Item.all.order(:number)

    respond_to :js
  end

  def filter 
    @cart = Cart.find(params[:cart])
    @subcat = Subcategory.find(params[:subcat])
    @subcat_id = @subcat.id

    @items = @subcat.items.order(:number)

  end

  def search
    @cart = Cart.find(params[:cart])

    @search = params[:find].to_s
    
    @sterm = Searchterm.where("name like ?", "%#{params[:find]}%")

    if @sterm.any?
      @items = @sterm.last.items
    else
      @items = Item.all.order(:number)
    end

  end

  def show
    @item = Item.find(params[:id])

    unless params[:subcat_id].nil?

      @subcat_id = Subcategory.find(params[:subcat_id]).id

    end

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

  def next
    @item = Item.find(params[:id])
    @cart = Cart.find(params[:cart])

    if params[:subcat_id].nil?
      @item_ids = Item.all.order(:number).pluck(:id)
    else
      @item_ids = Subcategory.find(params[:subcat_id]).items.order(:number).pluck(:id)
    end
    hash = Hash[@item_ids.map.with_index.to_a]
    index = hash[@item.id] + 1

    if index > @item_ids.count - 1
      index = 0
    end

    @item = Item.find(@item_ids[index])

    respond_to do |format|
      format.js
    end
  end

  def previous
    @item = Item.find(params[:id])
    @cart = Cart.find(params[:cart])

    if params[:subcat_id].nil?
      @item_ids = Item.all.order(:number).pluck(:id)
    else
      @item_ids = Subcategory.find(params[:subcat_id]).items.order(:number).pluck(:id)
    end
    hash = Hash[@item_ids.map.with_index.to_a]
    index = hash[@item.id] - 1

    if index < 0
      index = @item_ids.count - 1
    end

    @item = Item.find(@item_ids[index])

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

  end

  def update_items
    @cart = Cart.find_by_cart_id(params[:cart_id])

    @cart.update(cart_params)

    @cart.price = 0

    @cart.items.each do |item|
      quantity = @cart.cart_items.where(:item_id => item.id).last.quantity
      if quantity == 0
        @cart.items.delete(item)
      else
        @cart.price = @cart.price + (item.price*quantity)
      end
    end

    unless Zipcode.pluck(:zip_code).include? @cart.zip_code
      @cart.price = @cart.price + 12
    end

    @cart.save

    redirect_to new_corder_path(@cart.cart_id)
  end

  def cart
    @items = Item.all.order(:number)
    @cart = Cart.find_by_cart_id(params[:cart_id])

    respond_to do |format|
      format.html
      format.mobile
    end
  end

  def create
    @item = Item.new(item_params)
    @item.save
    redirect_to edit_item_path(@item), notice: "Item created, please add search terms"
  end

  def update
    @item.update(item_params)

    redirect_to items_path, notice: "Item saved"

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
      params.require(:item).permit(:name, :price, :item_id, :main, :number, :thumb, :subcategory_id, :per_page, :category_ids => [])
    end

    def cart_params
      params.require(:cart).permit(:cart_type, cart_items_attributes: [:id, :quantity])
    end
end
