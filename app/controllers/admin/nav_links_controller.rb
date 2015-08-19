class Admin::NavLinksController < ApplicationController
  before_action :set_nav_link, only: [:show, :edit, :update, :destroy]

  respond_to :html

  before_action :require_admin


  def require_admin
    unless current_user.try(:admin)
      redirect_to root_path
    end
  end

  def csv
  end

  def import
    NavLink.import(params[:file])
      redirect_to admin_csv_nav_links_path, notice: "navlinks imported."
  end

  def index
    @nav_links = NavLink.all
    respond_with(@nav_links)
  end

  def show
    @nav_link = NavLink.find(params[:id])
  end

  def new
    @nav_link = NavLink.new
    respond_with(@nav_link)
  end

  def edit
    @nav_link = NavLink.find(params[:id])
  end

  def create
    @nav_link = NavLink.new(nav_link_params)
    @nav_link.save
    redirect_to admin_nav_links_path, notice: "Nav Link successfully created."
  end

  def update
    @nav_link = NavLink.find(params[:id])
    @nav_link.update(nav_link_params)
    redirect_to admin_nav_links_path, notice: "Nav Link successfully updated."
  end

  def destroy
    @nav_link = NavLink.find(params[:id])
    @nav_link.destroy
    redirect_to admin_nav_links_path, notice: "Nav Link successfully destroyed."
  end

  private
    def set_nav_link
      @nav_link = NavLink.find(params[:id])
    end

    def nav_link_params
      params.require(:nav_link).permit(:title, :slug, :lft, :rgt, :parent_id, :position)
    end
end
