class TemplatesController < ApplicationController
  before_action :set_template, :require_admin, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @templates = Template.all
    respond_with(@templates)
  end

  def show
    respond_with(@template)
  end

  def new
    @template = Template.new
    respond_with(@template)
  end

  def edit
  end

  def create
    @template = Template.new(template_params)
    @template.save
    respond_with(@template)
  end

  def update
    @template.update(template_params)
    respond_with(@template)
  end

  def destroy
    @template.destroy
    respond_with(@template)
  end



  def require_admin
    unless current_user.try(:admin)
      redirect_to root_path
    end
  end

  private
    def set_template
      @template = Template.find(params[:id])
    end

    def template_params
      params[:template].permit(:name)
    end
end
