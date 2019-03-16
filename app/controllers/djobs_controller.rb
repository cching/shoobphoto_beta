class DjobsController < ApplicationController
  before_action :set_djob, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @djobs = Djob.all.order(:id)
    respond_to do |format|
        format.html
        format.csv {send_data @djobs.to_csv, filename: "Djobs.csv"}

    params[:q].reject { |_, v| v.blank?} if params[:q]

    @q = Djob.ransack(params[:q])
    @djobs = @q.result.includes(:school)
    end
  end

  def indexConfirms
    @djobs = Djob.all.order(:id)
    respond_to do |format|
        format.html
        format.csv {send_data @djobs.to_csv, filename: "Djobs.csv"}

    params[:q].reject { |_, v| v.blank?} if params[:q]

    @q = Djob.ransack(params[:q])
    @djobs = @q.result.includes(:school)
    end
  end

  def indexPhotography
    @djobs = Djob.all.order(:id)
    respond_to do |format|
        format.html
        format.csv {send_data @djobs.to_csv, filename: "Djobs.csv"}

    params[:q].reject { |_, v| v.blank?} if params[:q]

    @q = Djob.ransack(params[:q])
    @djobs = @q.result.includes(:school)
    end
  end

  def indexProduction
    @djobs = Djob.all.order(:id)
    respond_to do |format|
        format.html
        format.csv {send_data @djobs.to_csv, filename: "Djobs.csv"}

    params[:q].reject { |_, v| v.blank?} if params[:q]

    @q = Djob.ransack(params[:q])
    @djobs = @q.result.includes(:school)
    end
  end

  def show
  end

  def bysearch
    # sending q as params
   
    # @ djob = finds id that is included in the parameters 
    current_djob = Djob.find(params[:id])
    sequential_djob = current_djob.sequential_djob(params[:q], params[:direction].to_i)

    redirect_to edit_djob_path(sequential_djob, q: params[:q])
  end
    

  def new
    @djob = Djob.new
    @options = School.order(:name).
    collect do |s|
      [s.name, s.id]
    end

    respond_with(@djob)

  end

  
  def bydate
    @renderType = params[:type]
    new_params = params[:q] || { q: nil }
    date = new_params[:DATE_eq]
    direction = params[:direction].to_i

    new_date = date.nil? ? Time.now : Date.parse(date)
   
    new_params[:DATE_eq] = (new_date + direction).strftime('%Y-%m-%d')

    if @renderType == "confirms"
      redirect_to djobsconfirms_path(q: new_params)
    elsif @renderType == "photography"
      redirect_to djobsphotography_path(q: new_params)
    else
      redirect_to djobsproduction_path(q: new_params)
    end

  end

  def edit
    @renderType = params[:type]
    @q = params[:q]
  end

  def create
      @djob = Djob.new(djob_params)
      if @djob.save
        redirect_to "/djobs"
      else
        redirect_to "/djobs/new"
      end
      # respond_with(@djob)
    end

  def update
    @r = params[:type]
    q ={}
    q[:DATE_eq] = params[:djob].delete(:DATE_eq)
    q[:school_name_eq] = params[:djob].delete(:school_name_eq)
    q[:JOBTYPE_eq] = params[:djob].delete(:JOBTYPE_eq)
    q[:CONF_YN_eq] = params[:djob].delete(:CONF_YN_eq)
    q[:s] = params[:djob].delete(:s)

    @djob.update(djob_params)
    @djob.save

    if @r == "Update Confirms"
      redirect_to djobsconfirms_path(q: q)
    elsif @r == "Update Photography"
      redirect_to djobsphotography_path(q: q)
    elsif @r == "Update Production"
      redirect_to djobsproduction_path(q: q)
    else
      redirect_to "djobs/new"
    end

  end

  def destroy
    @djob.destroy
    redirect_to djobsconfirms_path
  end

  def import
    Djob.import(params[:file])
    #After import, redirects and lets us know it worked
    redirect_to "/djobsconfirms", notice: "Jobs added successfully"

  end

  private
    def set_djob
      @djob = Djob.find(params[:id])
    end

    def djob_params
      params.require(:djob).permit(:SCODE, :JOB, :JOBTYPE, :DATE, :STARTTIME, :TRIGS, :PRICELIST, :RIGS, :PHOTOG1, :PHOTOG_NOTE, :JOB_NOTES, :LAB_NOTE, 
      :PACK_NOTES, :LOCATION, :PROJSALE, :SALE, :ESTSHOTS, :FLYERS, :NOTICES, :POSTERS, :NOTICE_NOTE, :CONF_CALL, :RECONFIRM_CALL, :DATA_CALL, :DATA_REC, 
      :DATA_SETUP, :DATA2WEB, :LAPTOPS, :CROP_DATE, :CROP_NOTE, :TYPE_DATE, :TYPED_BY, :CORR_DATE, :CORR_BY, :DATA_CLEAN, :IMG2WEB, :PRINT_DATE, :PRINT_BY, 
      :ID_SHIP, :PKS_SHIP, :PKS_NOTE, :MUG_SHIP, :CR_SHIP, :PICS4TEA, :CP_PROOF_PRINTED, :CP_PROOF_SHIPPED, :CP_NOTES, :CP_PROOF_RET, :CP_CORR, :CP_PRINTED, 
      :CP_SHIP, :ADMIN_CD, :YB_UG_CD, :YB_SENR_CD, :PRIN_ALBUM, :TSHOTS, :TPKS, :ZPKS, :AVPK, :CONF_YN, :CONF, :RECONF, :RECONFYN, :school_id, :status)
    end
end

