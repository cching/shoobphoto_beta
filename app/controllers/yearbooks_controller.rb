class YearbooksController < ApplicationController
  before_action :set_yearbook, only: [:show, :edit, :update, :destroy]

  respond_to :html
  before_action :require_login


  def require_login
    unless current_user
      redirect_to root_path
    end
  end
  def buy
    @yearbook = Yearbook.new
    @student = Student.find(params[:id])
  end

  def dashboard
  end

  def schools
    @schools = School.all.order(:name)
    respond_to :js
  end

  def school_user
    @school = School.find(params[:id])

    @yearbooks = []
    @carts = []

    @school.students.each do |student|
      if student.yearbooks.any?
        student.yearbooks.each do |yearbook|
          @yearbooks << yearbook
        end
      end
      if student.carts.any?
        student.carts.each do |cart|
          if cart.purchased?
            cart.order_packages.each do |order|
              if order.package_id == 7
                @carts << cart
              end
            end
          end
        end
      end
    end
  end

  def index
    
    @school = current_user.school
    @yearbooks = []
    @carts = []

    @school.students.each do |student|
      if student.yearbooks.any?
        student.yearbooks.each do |yearbook|
          @yearbooks << yearbook
        end
      end
      if student.carts.any?
        student.carts.each do |cart|
          if cart.purchased?
            cart.order_packages.each do |order|
              if order.package_id == 7
                @carts << cart
              end
            end
          end
        end
      end
    end

    respond_with(@yearbooks)
  end

  def show
  @yearbooks = params[:yearbooks]
  @carts = params[:carts]
  @school = params[:school]
  respond_to do |format|
    format.html
    format.pdf do
      pdf = YearbookPdf.new(@carts, @yearbooks, @school)
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
      params.require(:yearbook).permit(:date, :quantity, :amount, :student_id)
    end
end
