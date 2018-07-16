class DprojectsController < ApplicationController
  before_action :set_dproject, only: [:show, :edit, :update, :destroy]
  before_action :require_admin

  respond_to :html

  def packingslip
    @dproject = Dproject.find(params[:id])
  end

  def invoice
    @dproject = Dproject.find(params[:id])
  end

  def index
    @dprojects = Dproject.order(params[:sort])
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
    end
  end

  def create
    @dproject = Dproject.new(dproject_params)
    @dproject.save
    redirect_to "/dprojects"
    # respond_with(@dproject)
  end

  def update
    @dproject.update(dproject_params)
    @dproject.save
    redirect_to "/dprojects"
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
      params.require(:dproject).permit(:scode, :description, :requested_by, :assigned_to, :completed_at, :order_num, :contact, :contact_email, :ptype, :due_date, :must_date, :print_date, :proofs_out, :proofs_in, :status, :delivery_type, :route, :delivery_date, :tracking_number, :shipping_instructions, :delivered, :printing_instructions, :project_changes, :project_path, :project_type, :assigned_by, :design_instructions, :dfile, :school_id, :invoice_date, :invoice_addressee, :invoice_description, :invoice_subtotal, :invoice_credit, :invoice_credit, :invoice_shipping, :invoice_sales_tax, :invoice_total, :invoice_paid, :invoice_payment_date, :invoice_notes, :invoice_bool)
    end
end
