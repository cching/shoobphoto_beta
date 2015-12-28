class ExportListsController < ApplicationController
  before_action :set_export_list, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @export_lists = ExportList.all
    respond_with(@export_lists)
  end

  def show
    respond_with(@export_list)
  end

  def new
    @export_list = ExportList.new
    
    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def create
    @export_list = ExportList.new(export_list_params)
    @export_list.save
    respond_with(@export_list)
  end

  def update
    @export_list.update(export_list_params)
    respond_with(@export_list)
  end

  def destroy
    @export_list.destroy
    respond_with(@export_list)
  end

  private
    def set_export_list
      @export_list = ExportList.find(params[:id])
    end

    def export_list_params
      params[:export_list]
    end
end
