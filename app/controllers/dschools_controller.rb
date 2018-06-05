class DschoolsController < ApplicationController
  before_action :set_dschool, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @dschools = Dschool.all
    respond_with(@dschools)
  end

  def show
    respond_with(@dschool)
  end

  def new
    @dschool = Dschool.new
    respond_with(@dschool)
  end

  def edit
  end

  def create
    @dschool = Dschool.new(dschool_params)
    @dschool.save
    respond_with(@dschool)
  end

  def update
    @dschool.update(dschool_params)
    respond_with(@dschool)
  end

  def destroy
    @dschool.destroy
    respond_with(@dschool)
  end

  private
    def set_dschool
      @dschool = Dschool.find(params[:id])
    end

    def dschool_params
      params.require(:dschool).permit(:scode, :name)
    end
end
