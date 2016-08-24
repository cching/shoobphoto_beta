class Admin::ExtraTypesController < ApplicationController
  before_action :set_extra_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @extra_types = ExtraType.all
    respond_with(@extra_types)
  end

  def show
    @extra_type = ExtraType.find(params[:id])
  end

  def new
    @extra_type = ExtraType.new
    respond_with(@extra_type)
  end

  def edit
    @extra_type = ExtraType.find(params[:id])
  end

  def create
    @extra_type = ExtraType.new(extra_type_params)
    @extra_type.save
    redirect_to admin_extra_types_path
  end

  def update
    @extra_type.update(extra_type_params)
    redirect_to admin_extra_types_path
  end

  def destroy
    @extra_type.destroy
    redirect_to admin_extra_types_path
  end

  private
    def set_extra_type
      @extra_type = ExtraType.find(params[:id])
    end

    def extra_type_params
      params.require(:extra_type).permit(:name, :required, :multiple, options_attributes: [:id], extras_attributes: [:id, :name, :extra_type_id, :image, :quantity, :_destroy, prices_attributes: [:id, :price, :enddate, :begin, :school_id, :_destroy]], :option_ids => [], :extra_ids => [])
    end
end
