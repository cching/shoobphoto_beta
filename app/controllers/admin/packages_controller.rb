class Admin::PackagesController < ApplicationController
require 'smarter_csv'
  respond_to :html

  before_action :require_admin


  def require_admin
    unless current_user.try(:admin)
      redirect_to root_path
    end
  end

  def copy
    @package = Package.find(params[:id])
    @package1 = @package.dup

    @package1.save
    @package1.image = @package.image
    @package1.save


    
    @package.shippings.each do |shipping|
        s = shipping.dup
        s.update(:package_id => @package1.id)
    end

    @package.options.each do |option|
      o = option.dup
      o.update(:package_id => @package1.id)

      option.prices.each do |price|
        p = price.dup
        p.update(:option_id => o.id)
      end

      option.image_types.each do |type|
        t = type.dup
        t.update(:option_id => o.id)
      end
    end

    
    redirect_to edit_admin_package_path(@package1.id)

  end

  def index
    @packages = Package.all.order(:name)
  end

  def carts 
  end

  def export_carts
    export = Export.create
      CartExport.perform_async(export.id)

      redirect_to carts_admin_packages_path, notice: "The new order CSV is currently being generated."
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

    file = File.open(params[:file].tempfile, "r:ISO-8859-1")

    chunk = SmarterCSV.process(file, {:chunk_size => 500, row_sep: :auto}) do |chunk|
      PackageImport.perform_async(chunk, @package.id, @school.id)
    end
    file.close
    redirect_to admin_csv_packages_path, notice: "Student packages successfully imported."
  end

  private

    def package_params
      params.require(:package).permit(:name, :image, :banner, :folder, :schools, :options, :multiple, :slug, :default_url, :default_folder, shippings_attributes: [:id, :price, :school_id, :_destroy], options_attributes: [:id, :price, :name, :poses, :without, :download, :_destroy, image_types_attributes: [:id, :_destroy, :name], prices_attributes: [:id, :price, :enddate, :begin, :school_id, :_destroy]], :school_ids => [])
    end
end
