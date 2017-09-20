class PordersController < ApplicationController
  before_action :set_porder, only: [:show, :edit, :update, :destroy]

  # GET /porders
  # GET /porders.json
  def index
    @porders = Porder.all
  end

  # GET /porders/1
  # GET /porders/1.json
  def show
  end

  # GET /porders/new
  def new
    @project = Project.find(params[:project_id])
    @free = @project.price > 0 ? false : true
    @porder = Porder.new(:project_id => @project.id, :free => @free, :price => @project.price)
  end

  # GET /porders/1/edit
  def edit
  end

  # POST /porders
  # POST /porders.json
  def create
    @porder = Porder.new(porder_params)

    respond_to do |format|
      if @porder.save
        format.html { redirect_to @porder, notice: 'Porder was successfully created.' }
        format.json { render :show, status: :created, location: @porder }
      else
        format.html { render :new }
        format.json { render json: @porder.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm
    @project = Project.find(params[:project_id])
    if @project.price > 0
      free = false
    else
      free = true
    end

    @porder = @project.porders.new(porder_params)
    @porder.price = @project.price
    @porder.free = free

    if @porder.save
        PorderMailer.receipt(@porder).deliver
        redirect_to after_purchase_porders_path
      else
        respond_to do |format|
        format.html { render 'new', :price => @porder.price, :free => free, :project => @project }
          format.json { render json: @porder.errors, status: :unprocessable_entity }

          end 
      end
  end

  # DELETE /porders/1
  # DELETE /porders/1.json
  def destroy
    @porder.destroy
    respond_to do |format|
      format.html { redirect_to porders_url, notice: 'Porder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_porder
      @porder = Porder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def porder_params
      params.require(:porder).permit(:project_id, :purchase_order, :price, :address, :city, :state, :zip_code, :card_type, :card_expires_on, :card_number, :card_verification, :shipping_state, :processed, :shipping_address, :shipping_zip, :shipping_city)
    end
end
