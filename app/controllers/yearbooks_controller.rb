 class YearbooksController < ApplicationController
  before_action :set_yearbook, only: [:show, :edit, :update, :destroy]

  respond_to :html
  before_action :require_login


  def require_login
    unless current_user
      redirect_to new_user_session_path 
    end
  end
  def buy
    @yearbook = Yearbook.new
    @student = Student.find(params[:id])
  end

  def dashboard
  end

  def schools
    @schools = School.where.not(school_type_id: nil).order(:name)
    respond_to :js
  end

  def school_user
    @school = School.find(params[:id])
    YearbookCache.perform_async(@school.id)

    if @school.yearbook_cache.nil? && @school.student_cache.nil?
      @yearbooks = []
      @students = []

    else

      @yearbooks = Yearbook.where(id: @school.yearbook_cache.split(","))  unless @school.yearbook_cache.nil?
      @students = Student.where(id: @school.student_cache.split(","))  unless @school.student_cache.nil?

    end

    
  end

  def index
    @school = current_user.school
    YearbookCache.perform_async(@school.id)

    if @school.yearbook_cache.nil? && @school.student_cache.nil?
      @yearbooks = []
      @students = []

    else

      @yearbooks = Yearbook.where(id: @school.yearbook_cache.split(","))  unless @school.yearbook_cache.nil?
      @students = Student.where(id: @school.student_cache.split(","))  unless @school.student_cache.nil?

    end
    

    respond_with(@yearbooks)
  end

  def show
  @yearbooks = params[:yearbooks]
  @students = params[:students]
  @school = params[:school]
  respond_to do |format|
    format.html
    format.pdf do
      pdf = YearbookPdf.new(@students, @yearbooks, @school)
      send_data pdf.render, filename: "test",
                            type: "application/pdf",
                            disposition: "inline"
    end
  end
end

  def new
    @yearbook = Yearbook.new
    respond_with(@yearbook)
  end

  def edit
  end

  def create
    @yearbook = Yearbook.new(yearbook_params)
    @yearbook.save

    respond_to :js
  end

  def update
    @yearbook.update(yearbook_params)
    respond_with(@yearbook)
  end

  def destroy
    @yearbook.destroy
    respond_with(@yearbook)
  end

  private
    def set_yearbook
      @yearbook = Yearbook.find(params[:id])
    end

    def yearbook_params
      params.require(:yearbook).permit(:date, :quantity, :amount, :student_id, :notes, :payment_type, :sold_by)
    end
end
