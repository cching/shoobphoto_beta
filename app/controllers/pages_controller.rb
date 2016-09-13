class PagesController < ApplicationController
  before_action :set_params_id, only: [:show, :edit, :update, :destroy]

  respond_to :html
  include Mobylette::RespondToMobileRequests
  layout 'fullwidth'

  def show
    @page = Page.find(params[:id])
    @links = NavLink.roots.find_by_slug(@page.root.slug).try(:children)
  end

  def menu
  end

  def close_menu
  end

  def after_purchase
    respond_to do |format|
        format.html
        format.mobile
      end
  end

  def home
        

      respond_to do |format|
        format.html
        format.mobile
      end
    end

  private
    def set_params_id
      params[:id] ||= Page.find_by_slug(params[:page].split('/')[-1]).id
    end

    def page_params
      params.require(:page).permit(:title, :body, :slug, :lft, :rgt, :parent_id)
    end


end
