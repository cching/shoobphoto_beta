class SchoolNotesController < ApplicationController
  before_action :set_school_note, only: [:show, :edit, :update, :destroy, :updatenote]
  include Mobylette::RespondToMobileRequests

  respond_to :html

  def index
    @notes = Note.all.pluck(:school_id).uniq
    @school_notes = School.find(@notes)
    
    respond_to do |format|
      format.html
      format.mobile
    end
  end

  def show
    respond_with(@school_note)
  end

  def note
    @school_note = School.find(params[:id])
    @note = Note.find(params[:note])
    respond_to do |format|
      format.html
      format.mobile
    end
  end

  def updatenote
    @school_note.update(school_note_params)
    redirect_to school_notes_path
  end

  def search
    @district = District.all.order(:name)
    respond_to do |format|
      format.html
      format.mobile
    end

  end

  def school
    @school = School.find(params[:school][:id])
    respond_to do |format|
      format.html
      format.mobile
    end
  end

  def schools
    @schools = School.all
  end

  def district
    @district = District.find(params[:districts][:id])
    District.update_all(:last => false)
    @district.update(:last => true)
    @schools = @district.schools.all.order(:name)
  end

  def last
    @district = District.where(:last => true).last
    @schools = @district.schools.all.order(:name)
  end

  def edit
  end

  def create
    @school_note = School.new(school_note_params)
    @school_note.save
    respond_with(@school_note)
  end

  def update
    @school_note.update(school_note_params)
    respond_with(@school_note)
  end

  def destroy
    @school_note.destroy
    respond_with(@school_note)
  end

  private
    def set_school_note
      @school_note = School.find(params[:id])
    end

    def school_note_params
      params.require(:school).permit(:cdscode, :name, :district_id, :city_id, :address, :phone, :principle, :secretary, :notes_attributes => [:note, :created_at, :_destroy, :id, :action, :response, :complete])
    end
end
