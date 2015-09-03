class Admin::BannersController < ApplicationController
  before_action :set_banner, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @banners = Banner.all
    respond_with(@banners)
  end

  def show
    @banner = Banner.find(params[:id])
  end

  def new
    @banner = Banner.new
  end

  def edit
    @banner = Banner.find(params[:id])
  end

  def create
    @banner = Banner.new(banner_params)
    @banner.save
    redirect_to admin_banners_path
  end

  def update
    @banner.update(banner_params)
    redirect_to admin_banners_path
  end

  def destroy
    @banner.destroy
    redirect_to admin_banners_path
  end

  private
    def set_banner
      @banner = Banner.find(params[:id])
    end

    def banner_params
      params.require(:banner).permit(:school_type_id, :image)
    end
end
