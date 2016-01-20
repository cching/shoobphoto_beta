class Admin::ExtrasController < ApplicationController
  before_action :set_extra, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @extras = Extra.all
    respond_with(@extras)
  end

  def show
    @extra = Extra.find(params[:id])
  end

  def new
    @extra = Extra.new
    
  end

  def edit
    @extra = Extra.find(params[:id])
  end

  def create
    @extra = Extra.new(extra_params)
    @extra.save
    redirect_to admin_extras_path
  end

  def update
    @extra.update(extra_params)
    redirect_to admin_extras_path
  end

  def destroy
    @extra.destroy
    redirect_to admin_extras_path
  end

  private
    def set_extra
      @extra = Extra.find(params[:id])
    end

    def extra_params
      params.require(:extra).permit(:name, :extra_type_id, :image, :quantity, prices_attributes: [:id, :price, :enddate, :begin, :school_id, :_destroy])
    end
end
