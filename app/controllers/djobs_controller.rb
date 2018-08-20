class DjobsController < ApplicationController
  before_action :set_djob, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    params[:q].reject { |_, v| v.blank?} if params[:q]

    @q = Djob.ransack(params[:q])
    @djob = @q.result.includes(:school)
    require 'date'
    respond_with(@djob)
  end

  def show
    redirect_to request.path + "/edit", :status => :moved_permanently 
  end

  def new
    @djob = Djob.new
    @options = School.order(:name).where.not(school_type_id: nil).
    collect do |s|
      [s.name, s.id]
    end

    respond_with(@djob)

  end

  
  def bydate
    new_params = params[:q] || { q: nil }
    date = new_params[:DATE_eq]
    direction = params[:direction].to_i


    new_date = date.nil? ? Time.now : Date.parse(date)
   
    new_params[:DATE_eq] = (new_date + direction).strftime('%Y-%m-%d')

    
    redirect_to djobs_path(q: new_params)

  end

  def edit
  end

  def create
    @djob = Djob.new(djob_params)
    @djob.save
    respond_with(@djob)
  end

  def update
    q ={}
    q[:DATE_eq] = params[:djob].delete(:DATE_eq)
    q[:school_name_eq] = params[:djob].delete(:school_name_eq)
    q[:s] = params[:djob].delete(:s)


    @djob.update(djob_params)
    redirect_to djobs_path(q: q)
  end

  def destroy
    @djob.destroy
    respond_with(@djob)
  end

  def import
    Djob.import(params[:file])
    #After import, redirects and lets us know it worked
    redirect_to "/djobs", notice: "Jobs added successfully"

  end

  private
    def set_djob
      @djob = Djob.find(params[:id])
    end

    def djob_params
      params.require(:djob).permit(:SCODE, :JOB, :JOBTYPE, :DATE, :STARTTIME, :TRIGS, :PRICELIST, :RIGS, :PHOTOG1, :PHOTOG_NOTE, :JOB_NOTES, :LAB_NOTE, :PACK_NOTES, :LOCATION, :PROJSALE, :SALE, :ESTSHOTS, :FLYERS, :NOTICES, :POSTERS, :NOTICE_NOTE, :CONF_CALL, :RECONFIRM_CALL, :DATA_CALL, :DATA_REC, :DATA_SETUP, :DATA2WEB, :LAPTOPS, :CROP_DATE, :CROP_NOTE, :TYPE_DATE, :TYPED_BY, :CORR_DATE, :CORR_BY, :DATA_CLEAN, :IMG2WEB, :PRINT_DATE, :PRINT_BY, :ID_SHIP, :PKS_SHIP, :PKS_NOTE, :MUG_SHIP, :CR_SHIP, :PICS4TEA, :CP_PROOF_PRINTED, :CP_PROOF_SHIPPED, :CP_NOTES, :CP_PROOF_RET, :CP_CORR, :CP_PRINTED, :CP_SHIP, :ADMIN_CD, :YB_UG_CD, :YB_SENR_CD, :PRIN_ALBUM, :TSHOTS, :TPKS, :ZPKS, :AVPK, :CONF_YN, :CONF, :school_id, :status)
    end
end

