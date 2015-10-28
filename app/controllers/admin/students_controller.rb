class Admin::StudentsController < ApplicationController
  before_action :require_admin

	def index
		@students = Student.paginate(:page => params[:page], :per_page => 100)
	end

	def csv
	end

	def import
		file = File.open(params[:file].tempfile, "r:ISO-8859-1")

    chunk = SmarterCSV.process(file, {:chunk_size => 500, row_sep: :auto}) do |chunk|
      Student.import(chunk)
    end
    file.close
  		redirect_to admin_csv_students_path, notice: "Students imported."
	end

	def where_empty
		school = School.find(params[:school])
		@students = StudentsHelper.find_by_school(school)
	end

	def require_admin
    unless current_user.try(:admin)
      redirect_to root_path
    end
  end
end