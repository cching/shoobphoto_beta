class AutosController < ApplicationController
  before_action :set_auto, only: [:show, :edit, :update, :destroy, :process_auto]

  respond_to :html

  def start_auto

    #clear database of previous
    Auto.delete_all
    StudentError.delete_all ## double check

    ##add error/success count

    @auto = Auto.create(:success_count => 0, :failed_count => 0)
    s3 = AWS::S3.new
    
    bucket = AWS::S3::Bucket.new('shoobphoto')
    objects = bucket.objects.with_prefix('AutoCSV/output').collect(&:key).drop(1)

    objects.each do |object|
      csv_path  = "https://s3-us-west-1.amazonaws.com/shoobphoto/#{object}"

      csv_file  = open(csv_path,'r')

      chunk = SmarterCSV.process(csv_file, {:chunk_size => 2000, :file_encoding =>'iso-8859-1'}) do |chunk|
        AutoImport.perform_async(chunk, object, @auto.id)
      end
 
    end

    objects.each do |object| #clear database csv
      obj = s3.buckets['shoobphoto'].objects[object] # no request made
      obj.delete
    end

    objects = bucket.objects.with_prefix('AutoCSV/failed').collect(&:key).drop(1)

    objects.each do |object| #clear failure csv
      csv_path  = "https://s3-us-west-1.amazonaws.com/shoobphoto/#{object}"

      csv_file  = open(csv_path,'r')

      chunk = SmarterCSV.process(csv_file, {:chunk_size => 500, :file_encoding =>'iso-8859-1'}) do |chunk|
        AutoImportError.perform_async(chunk, object, @auto.id)
      end
 
    end

    objects.each do |object| 
      obj = s3.buckets['shoobphoto'].objects[object] # no request made
      obj.delete
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
