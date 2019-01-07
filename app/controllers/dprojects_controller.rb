require 'barby'
require 'barby/barcode/ean_13'
require 'barby/barcode/code_39'
require 'barby/outputter/ascii_outputter'
require 'barby/outputter/html_outputter'
require 'barby/outputter/png_outputter'

class DprojectsController < ApplicationController
  before_action :set_dproject, only: [:show, :edit, :update, :destroy]
  before_action :require_employee

  respond_to :html

  def packingslip
    @dproject = Dproject.find(params[:id])
    @barcodenumber = @dproject.id.to_s.rjust(12, "0")
    @barcode = Barby::Code39.new(@barcodenumber)
    @barcode_for_html =Barby::PngOutputter.new(@barcode).to_png
    # generate_barcodes(@dproject)
    respond_to do |format|
      format.html
      format.png do
        send_data @barcode_for_html, type: "image/png", disposition: "inline"
      end
    end
  end

  def bysearch
    current_dproject = Dproject.find(params[:id])
    sequential_dproject = current_dproject.sequential_dproject(params[:q], params[:direction].to_i)

    redirect_to edit_dproject_path(sequential_dproject, q: params[:q])
  
  end

  def invoice
    @dproject = dproject.new 
    @invoice = Invoice.find(params[:id])
    @invoice = Invoice.new 
    @dproject = Dproject.find(params[:id])
  end

  def attachment
    @dproject = Dproject.find(params[:id])
  end

  def ship
    @dproject = Dproject.find(params[:id])
  end

  def shipreport

  end

  def index
    params[:q].reject { |_, v| v.blank? } if params[:q]

    @q = Dproject.ransack(params[:q])
    @dprojects = @q.result.includes(:school)
    respond_with(@dprojects)
  end

  def show
    redirect_to request.path + "/edit", :status => :moved_permanently 
  end

  def new
    @dproject = Dproject.new
    @options = School.order(:name).where.not(school_type_id: nil).
    collect do |s|
      [s.name, s.id]
    end
    respond_with(@dproject)
  end

  def sort
    if params[:query] == 'by_school'
      @dprojects.by_school.where.not(status: "Completed")
    else
      @dproject.select { |dproject| dproject.assigned_to == param } # column name
    end

    respond_with :js

  end

  def edit
    @dproject = Dproject.find(params[:id])
    @options = School.order(:name).where.not(school_type_id: nil).
    collect do |s|
      [s.name, s.id]
    @q = params[:q]
    end
  end

  def create
    @dproject = Dproject.new(dproject_params)
    if @dproject.save
      redirect_to "/dprojects"
    else
      redirect_to "/dprojects/new"
    end
    # respond_with(@dproject)
  end

  def update
    q = {}
    q[:assigned_to_eq] = params[:dproject].delete(:assigned_to_eq)
    q[:status_eq] = params[:dproject].delete(:status_eq)
    q[:school_name_eq] = params[:dproject].delete(:school_name_eq)
    q[:school_route_eq] = params[:dproject].delete(:school_route_eq)
    q[:id_eq] = params[:dproject].delete(:id_eq)
    q[:invoice_status_eq] = params[:dproject].delete(:invoice_status_eq)
    q[:project_type_eq] = params[:dproject].delete(:project_type_eq)

    q[:s] = params[:dproject].delete(:s)
    @dproject.update(dproject_params)
    @dproject.save
    redirect_to dprojects_path(q: q)
    # respond_with(@dproject)
  end

  def destroy
    @dproject.destroy
    respond_with(@dproject)
  end

  private
    def set_dproject
      @dproject = Dproject.find(params[:id])
    end
    def dproject_params
      params.require(:dproject).permit(:scode, :description, :requested_by, :assigned_to, 
      :completed_at, :order_num, :contact, :contact_email, :ptype, :due_date, :must_date, 
      :print_date, :proofs_out, :proofs_in, :status, :delivery_type, :route, :delivery_date, 
      :tracking_number, :shipping_instructions, :delivered, :printing_instructions, 
      :project_changes, :project_path, :project_type, :assigned_by, :design_instructions, 
      :dfile, :school_id, :invoice_date, :invoice_addressee, :invoice_description, 
      :invoice_subtotal, :invoice_credit, :invoice_credit, :invoice_shipping, 
      :invoice_sales_tax, :invoice_total, :invoice_paid, :invoice_payment_date, 
      :invoice_notes, :invoice_bool, :recieved_by, :boxes, :status_date, 
      :note_to_lab, :delivered_by, :invoice_status, :signature, :testattachment,
      dattachments_attributes: [:id, :dproject_id, :created_at, :updated_at, :dcomment, :afile], 
      lineitems_attributes: [:invoice_id, :id, :quantity, :product, :price, :extended_price, :sales_tax, :final_price])
    end
end