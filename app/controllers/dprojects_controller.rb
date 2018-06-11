class DprojectsController < ApplicationController
  before_action :set_dproject, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @dprojects = Dproject.all
    respond_with(@dprojects)
  end

  def show
    respond_with(@dproject)
  end

  def new
    @dproject = Dproject.new
    @options = School.order(:name).where.not(school_type_id: nil).
    collect do |s|
      [s.name, s.id]
    end
    respond_with(@dproject)
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
      params.require(:dproject).permit(:scode, :description, :requested_by, :assigned_to, :completed_at, :order_num, :contact, :contact_email, :ptype, :due_date, :must_date, :print_date, :proofs_out, :proofs_in, :status, :delivery_type, :route, :delivery_date, :tracking_number, :shipping_instructions, :invoicing, :delivered, :printing_instructions)
    end
end
