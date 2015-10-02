class FieldsController < ApplicationController
  before_action :set_field, only: [:show, :edit, :update, :destroy]
  before_action :set_template
  respond_to :html

  def index

    @fields = @template.fields.all
    respond_with(@tempate, @fields)
  end

  def show
    respond_with(@tempate, @field)
  end

  def new
    @field = @template.fields.new
    respond_with(@tempate, @field)
  end

  def edit
  end

  def create
    @field = @template.fields.new(field_params)
    @field.save
    respond_with(@tempate, @field)
  end

  def update
    @field.update(field_params)
    respond_with(@tempate, @field)
  end

  def destroy
    @field.destroy
    respond_with(@tempate, @field)
  end

  private
    def set_field
      @field = Field.find(params[:id])
    end

    def set_template
      @template = Template.find(params[:template_id])
    end

    def field_params
      params[:field].permit(:x, :y, :height, :width, :align, :column, :template_id, :font, :font_id, :text_size, :spacing, :name, :color)
    end
end
