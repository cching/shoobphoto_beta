class DprojectsController < ApplicationController
  before_action :set_dproject, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @dprojects = Dproject.all
    respond_with(@dprojects)
  end

  def show
    respond_with(@dproject)
  end

  def new
    @dproject = Dproject.new
    respond_with(@dproject)
  end

  def edit
  end

  def create
    @dproject = Dproject.new(dproject_params)
    @dproject.save
    respond_with(@dproject)
  end

  def update
    @dproject.update(dproject_params)
    respond_with(@dproject)
  end

  def destroy
    @dproject.destroy
    respond_with(@dproject)
  end

  private
    def set_dproject
      @dproject = Dproject.find(params[:id])
    end

    def dproject_params
      params[:dproject]
    end
end
