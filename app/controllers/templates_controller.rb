class TemplatesController < ApplicationController
  before_action :set_template, :require_admin, only: [:show, :edit, :update, :destroy, :preview]

  respond_to :html

  def preview
    @template = Template.find(params[:id])
    fields = @template.columns.all.map {|column| column.fields.where(:template_id => @template.id).last.id }
    @template.fields.each do |field|
      unless fields.include? field.id
        field.delete
      end
    end
    

  end

  def copy
    @template = Template.find(params[:id])
    @template1 = @template.dup
    @template1.save
    
    @template.pdfs.each do |pdf|
      unless pdf.nil?
        p = pdf.dup
        p.file = pdf.file
        p.save
        p.update(:template_id => @template1.id)
        pdf.types.each do |type|
          unless type.nil?
            t = type.dup
            t.save
            t.schools = type.schools
            t.update(:pdf_id => p.id)
          end
        end
      end
    end

    @template.fields.each do |field|
      unless field.nil?
        f = field.dup
        f.save
        f.update(:template_id => @template1.id)
      end
    end

    
    redirect_to edit_template_path(@template1.id)

  end

  def index
    @templates = Template.all.order(:name)
    respond_with(@templates)
  end

  def show
    respond_with(@template)
  end

  def new
    @template = Template.create(:name => "New template")
    redirect_to edit_template_path(@template)
  end

  def edit
  end

  def create
    @template = Template.new(template_params)
    @template.save
    respond_with(@template)
  end

  def update
    @template.update(template_params)
    puts "@@@@@ #{@template.errors.full_messages}"


    if @template.types.where(:preview => true).any?
      typeid = @template.types.where(:preview => true).last.id
    else
      typeid = @template.types.last.id 
    end

    @export_data = @template.export_datas.new(( {}).merge({
      kind: 'print',
      type_id: typeid,
      user_id: current_user.id
    }))

    @export_data.export_data_students.new(:student_id => 129932)
    @export_data.save


    file_name = ["export-file-#{@export_data.id}", ".pdf"]
      Tempfile.open(file_name) do |file|
          DownloadPdf.new(@export_data, 8, file.path).generate
          @export_data.file = file
        @export_data.save
      end
        
    
    redirect_to edit_template_path(@template.id)
  end

  def destroy
    @template.destroy
    respond_with(@template)
  end



  def require_admin
    unless current_user.try(:admin)
      redirect_to root_path
    end
  end

  private
    def set_template
      @template = Template.find(params[:id])
    end

    def template_params
      params[:template].permit(:name, :category_ids, :column_ids => [], fields_attributes: [:id, :x, :y, :height, :width, :align, :column, :template_id, :font, :font_id, :text_size, :spacing, :name, :_destroy, :color, :_destroy], pdfs_attributes: [:id, :name, :file, :_destroy, :template_id, types_attributes: [:id, :name, :_destroy, :preview, :school_ids => []]])
    end
end
