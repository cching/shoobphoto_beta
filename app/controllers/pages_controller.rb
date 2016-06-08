class PagesController < ApplicationController
  before_action :set_params_id, only: [:show, :edit, :update, :destroy]

  respond_to :html


  def show
    @page = Page.find(params[:id])
    @links = NavLink.roots.find_by_slug(@page.root.slug).try(:children)
  end

  private
    def set_params_id
      params[:id] ||= Page.find_by_slug(params[:page].split('/')[-1]).id
    end

    def page_params
      params.require(:page).permit(:title, :body, :slug, :lft, :rgt, :parent_id)
    end
end
