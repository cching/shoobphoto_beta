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
    @options = School.order(:name).where.not(school_type_id: nil).
    collect do |s|
      [s.name, s.id]
    end
    respond_with(@dproject)
  end

  def edit
    @dproject = Dproject.find(params[:id])
    @options = School.order(:name).where.not(school_type_id: nil).
    collect do |s|
      [s.name, s.id]
    end
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
      params.require(:dproject).permit(:scode, :description, :requested_by, :assigned_to, :completed_at)
    end
end
