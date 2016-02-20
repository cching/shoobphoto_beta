class Admin::SchoolsController < ApplicationController
  before_action :set_school, only: [:show, :edit, :update, :destroy]

  respond_to :html

  before_action :require_admin


  def require_admin
    unless current_user.try(:admin)
      redirect_to root_path
    end
  end

  def index
    @schools = School.all.order(:name)
    respond_with(@schools)
  end

  def show 
    @school = School.find(params[:id])
  end

  def csv
    export = SchoolExport.create
      ExportSchool.perform_async(export.id)

      redirect_to export_admin_schools_path, notice: "The new order CSV is currently being generated."
  end

  def export
  end

  def new
    @school = School.new
    respond_with(@school)
  end

  def edit
  end

  def create
    @school = School.new(school_params)
    @school.save
    redirect_to admin_schools_path
  end

  def update
    @school.update(school_params)
    redirect_to admin_schools_path
  end

  def destroy
    @school.destroy
    redirect_to admin_schools_path
  end

  private
    def set_school
      @school = School.find(params[:id])
    end

    def school_params
      params[:school].permit(:name, :district_id, :city_id, :principal, :secretary, :address, :phone, :cdscode, :school_type_id, :ca_code, :package_ids => [])
    end
end
