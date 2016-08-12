class Admin::DashboardsController < ApplicationController
  before_action :require_admin


	  def require_admin
	    unless current_user.try(:admin)
	      redirect_to root_path
	    end
	  end

	  def index
	  end

  	def csv
	end

	def console
	end

	def import
	file = File.open(params[:file].tempfile, "r:ISO-8859-1")

    chunk = SmarterCSV.process(file, {:chunk_size => 500, row_sep: :auto}) do |chunk|
     	DownloadImport.perform_async(chunk, params[:school][:id])
    end
    file.close
  		redirect_to admin_dashboards_path, notice: "Download images are currently being imported."
	end

	def missing
		export = Missing.create
		MissingExport.perform_async(export.id)
		redirect_to csv_admin_dashboards_path, notice: "The CSV of missing images is being generated. This may take a while..."
	end



end
