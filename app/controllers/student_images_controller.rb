class StudentImagesController < ApplicationController
  before_action :set_student_image, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @student_images = StudentImage.all
    respond_with(@student_images)
  end

  def show
    respond_with(@student_image)
  end

  def new
    @student_image = StudentImage.new
    respond_with(@student_image)
  end

  def edit
  end

  def create
    @student_image = StudentImage.new(student_image_params)
    @student_image.save
    respond_with(@student_image)
  end

  def update
    @student_image.update(student_image_params)
    respond_with(@student_image)
  end

  def destroy
    @student_image.destroy
    respond_with(@student_image)
  end

  private
    def set_student_image
      @student_image = StudentImage.find(params[:id])
    end

    def student_image_params
      params.require(:student_image).permit(:package_id, :student_id)
    end
end
