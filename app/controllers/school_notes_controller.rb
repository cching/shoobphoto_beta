class SchoolNotesController < ApplicationController
  before_action :set_school_note, only: [:show, :edit, :update, :destroy, :updatenote]

  respond_to :html

  def index
    @notes = Note.all.pluck(:school_note_id).uniq
    @school_notes = SchoolNote.find(@notes)
    respond_with(@school_notes)
  end

  def show
    respond_with(@school_note)
  end

  def note
    @school_note = SchoolNote.find(params[:id])
    @note = Note.find(params[:note])
  end

  def updatenote
    @school_note.update(school_note_params)
    redirect_to school_notes_path
  end

  def search
    @district = District.all.order(:name)
  end

  def school
    @school = SchoolNote.find(params[:school][:id])
  end

  def district
    @district = District.find(params[:districts][:id])
    @schools = @district.school_notes.all.order(:name)
  end

  def edit
  end

  def create
    @school_note = SchoolNote.new(school_note_params)
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
      @school_note = SchoolNote.find(params[:id])
    end

    def school_note_params
      params.require(:school_note).permit(:cdscode, :name, :district_id, :city_id, :address, :phone, :principle, :secretary, :notes_attributes => [:note, :created_at, :_destroy, :id, :action, :response])
    end
end
