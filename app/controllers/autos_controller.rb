class AutosController < ApplicationController
  before_action :set_auto, only: [:show, :edit, :update, :destroy, :process_auto]

  respond_to :html

  def start_auto
    @auto = Auto.create
    
    bucket = AWS::S3::Bucket.new('shoobphoto')
    objects = bucket.objects.with_prefix('AutoCSV/output').collect(&:key).drop(1)

    objects.each do |object|
      csv_path  = "https://s3-us-west-1.amazonaws.com/shoobphoto/#{object}"

      csv_file  = open(csv_path,'r')

      chunk = SmarterCSV.process(csv_file, {:chunk_size => 500, row_sep: :auto}) do |chunk|
        AutoImport.perform_async(chunk, object, @auto.id)
      end

    end
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
    respond_with(@auto)
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
