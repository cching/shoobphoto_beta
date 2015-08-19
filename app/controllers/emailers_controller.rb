class EmailersController < ApplicationController
  before_action :require_admin


  def require_admin
    unless current_user.try(:admin)
      redirect_to root_path
    end
  end

  def index
  end

  def import
    @school = School.find(params[:school][:id])
    chunk = SmarterCSV.process(params[:file].tempfile, {:chunk_size => 500, row_sep: :auto}) do |chunk|
      EmailerImport.perform_async(chunk, @school.id, params[:prompt])
    end
    redirect_to admin_dashboards_path, notice: "Student packages successfully imported."
  end

end
