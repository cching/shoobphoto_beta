class PdfsController < ApplicationController
  before_action :set_pdf, only: [:show, :edit, :update, :destroy]
  before_action :set_template

  respond_to :html

  def index
    @pdfs = @template.pdfs.all
    respond_with(@template, @pdfs)
  end

  def show
    respond_with(@template, @pdf)
  end

  def new
    @pdf = @template.pdfs.new
    respond_with(@pdf)
  end

  def edit
  end

  def create
    @pdf = Pdf.new(pdf_params)
    @pdf.save
    respond_with(@template, @pdf)
  end

  def update
    @pdf.update(pdf_params)
    respond_with(@template, @pdf)
  end

  def destroy
    @pdf.destroy
    respond_with(@template, @pdf)
  end

  private
    def set_pdf
      @pdf = Pdf.find(params[:id])
    end

    def set_template
      @template = Template.find(params[:template_id])
    end

    def pdf_params
      params[:pdf].permit(:name, :template_id, :file)
    end
end
