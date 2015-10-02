class TypesController < ApplicationController
  before_action :set_type, only: [:show, :edit, :update, :destroy]
  before_action :set_template
  before_action :set_pdf

  respond_to :html

  def index
    @types = @pdf.types.all
    respond_with(@template, @pdf, @types)
  end

  def show
    respond_with(@template, @pdf, @types)
  end

  def new
    @type = @pdf.types.new
    respond_with(@template, @pdf, @types)
  end

  def edit
  end

  def create
    @type = @pdf.types.new(type_params)
    @type.save
    respond_with(@template, @pdf, @types)
  end

  def update
    @type.update(type_params)
    respond_with(@template, @pdf, @types)
  end

  def destroy
    @type.destroy
    respond_with(@template, @pdf, @types)
  end

  private
    def set_type
      @type = Type.find(params[:id])
    end

    def set_pdf
      @pdf = Pdf.find(params[:pdf_id])
    end

    def set_template
      @template = Template.find(params[:template_id])
    end

    def type_params
      params[:type].permit(:pdf_id, :name)
    end
end
