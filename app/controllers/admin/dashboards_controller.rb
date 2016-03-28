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

	def import
	file = File.open(params[:file].tempfile, "r:ISO-8859-1")

    chunk = SmarterCSV.process(file, {:chunk_size => 500, row_sep: :auto}) do |chunk|
     	DownloadImport.perform_async(chunk, params[:school])
    end
    file.close
  		redirect_to admin_dashboards_path, notice: "Download images are currently being imported."
	end

end
