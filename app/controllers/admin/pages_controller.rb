class Admin::PagesController < ApplicationController
  before_action :set_params_id, only: [:show, :edit, :update, :destroy]

  respond_to :html

  before_action :require_admin

  def csv
  end

  def import
    Page.import(params[:file])
      redirect_to admin_csv_pages_path, notice: "Pages imported."
  end

  def require_admin
    unless current_user.try(:admin)
      redirect_to root_path
    end
  end

  def index
    @pages = Page.all
    respond_with(@pages)
  end

  def show
    @page = Page.find(params[:id])
    @links = NavLink.roots.find_by_slug(@page.root.slug).try(:children)
  end

  def new
    @page = Page.new
    respond_with(@page)
  end

  def edit
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.new(page_params)
    @page.save
    redirect_to admin_pages_path, notice: "Page was successfully created."
  end

  def update
    @page = Page.find(params[:id])
    @page.update(page_params)
    redirect_to admin_pages_path, notice: "Page was successfully updated."
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    redirect_to admin_pages_path, notice: "Page was successfully deleted."
  end

  private
    def set_params_id
      params[:id] ||= Page.find_by_slug(params[:page].split('/')[-1]).id
    end

    def page_params
      params.require(:page).permit(:title, :body, :slug, :lft, :rgt, :parent_id)
    end
end
