class AutosController < ApplicationController
  before_action :set_auto, only: [:show, :edit, :update, :destroy, :process_auto]

  respond_to :html

  def start_import
      chunk = SmarterCSV.process("#{Rails.root}/public/csv/10.csv", {:chunk_size => 10000}) do |chunk|
        PackageImport.perform_async(chunk)
      end


    
  end


  def start_auto

    #clear database of previous
    Auto.delete_all
    StudentError.delete_all ## double check

    ##add error/success count

    @auto = Auto.create(:success_count => 0, :failed_count => 0)
    AutoImport.perform_async(@auto.id)
    
    redirect_to process_auto_auto_path(@auto.id)
  end

  def process_auto
    respond_with(@auto)
    
  end

  def index
    @autos = Auto.all
    respond_with(@autos)
  end

  def show

    respond_to do |format|
      format.js
    end
  end

  def new
    @auto = Auto.new
    respond_with(@auto)
  end

  def edit
  end

  def create
    @auto = Auto.new(auto_params)
    @auto.save
    respond_with(@auto)
  end

  def update
    @auto.update(auto_params)
    respond_with(@auto)
  end

  def destroy
    @auto.destroy
    respond_with(@auto)
  end

  private
    def set_auto
      @auto = Auto.find(params[:id])
    end

    def auto_params
      params[:auto]
    end
end
