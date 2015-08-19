class NavLinksController < ApplicationController
  before_action :set_nav_link, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @nav_links = NavLink.all
    respond_with(@nav_links)
  end

  def show
    respond_with(@nav_link)
  end

  def new
    @nav_link = NavLink.new
    respond_with(@nav_link)
  end

  def edit
  end

  def create
    @nav_link = NavLink.new(nav_link_params)
    @nav_link.save
    respond_with(@nav_link)
  end

  def update
    @nav_link.update(nav_link_params)
    respond_with(@nav_link)
  end

  def destroy
    @nav_link.destroy
    respond_with(@nav_link)
  end

  private
    def set_nav_link
      @nav_link = NavLink.find(params[:id])
    end

    def nav_link_params
      params.require(:nav_link).permit(:title, :slug, :lft, :rgt, :parent_id, :position)
    end
end
