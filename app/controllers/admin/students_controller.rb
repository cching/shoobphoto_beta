class Admin::StudentsController < ApplicationController
  before_action :require_admin

	def index
		@students = Student.paginate(:page => params[:page], :per_page => 100)
	end

	def csv
	end

	def import
		Student.import(params[:file])
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