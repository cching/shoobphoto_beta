class Admin::PackagesController < ApplicationController
require 'smarter_csv'
  respond_to :html

  before_action :require_admin


  def require_admin
    unless current_user.try(:admin)
      redirect_to root_path
    end
  end

  def index
    @packages = Package.all.order(:name)
  end

  def show
    @package = Package.find(params[:id])
  end

  def new
    @package = Package.new
    
  end

  def edit
    @package = Package.find(params[:id])
  end

  def create
    @package = Package.create(package_params)
    redirect_to admin_packages_path
  end

  def update
    @package = Package.find(params[:id])
    @package.update(package_params)
    redirect_to admin_packages_path, notice: "Package was successfully updated"
  end

  def destroy
    @package = Package.find(params[:id])
    @package.destroy
    redirect_to admin_packages_path
  end

  def csv
    @package = Package.find(params[:id])
  end

  def import
    @package = Package.find(params[:id])
    @school = School.find(params[:school][:id])
    chunk = SmarterCSV.process(params[:file].tempfile, {:chunk_size => 200, row_sep: :auto}) do |chunk|
      PackageImport.perform_async(chunk, @package.id, @school.id)
    end
    redirect_to admin_csv_packages_path, notice: "Student packages successfully imported."
  end

  private

    def package_params
      params.require(:package).permit(:name, :image, :banner, :folder, :schools, :options, :multiple, :slug, :default_url, :default_folder, shippings_attributes: [:id, :price, :school_id, :_destroy], options_attributes: [:id, :price, :name, :_destroy, image_types_attributes: [:id, :_destroy, :name], prices_attributes: [:id, :price, :enddate, :begin, :school_id, :_destroy]], :school_ids => [])
    end
end
