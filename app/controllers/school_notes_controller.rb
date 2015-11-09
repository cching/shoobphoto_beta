class SchoolNotesController < ApplicationController
  before_action :set_school_note, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @school_notes = SchoolNote.all
    respond_with(@school_notes)
  end

  def show
    respond_with(@school_note)
  end

  def new
    @school_note = SchoolNote.new
    respond_with(@school_note)
  end

  def search
    @district = District.all.order.(:name)
  end

  def district
    @district = District.find(params[:id])
    @schools = @district.schools.all.order(:name)
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
      params.require(:school_note).permit(:cdscode, :name, :district_id, :city_id, :address, :phone, :principle, :secretary)
    end
end
