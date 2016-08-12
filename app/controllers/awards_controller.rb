class AwardsController < ApplicationController
  before_action :set_award, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @awards = Award.all
    respond_with(@awards)
  end

  def show
    respond_with(@award)
  end

  def new
    @export_list = ExportList.new
    respond_with(@award)
  end

  def edit
  end

  def create
    @export_list = ExportList.new(export_list_params)
    @export_list.save
    @export_list.update(:uniq_id => SecureRandom.hex(8))

    redirect_to export_awards_path(@export_list.uniq_id)
  end

  def update
    @export_list.update(export_list_params)
    respond_with(@export_list)
  end

  def destroy
    @award.destroy
    respond_with(@award)
  end

  private
    def set_award
      @award = Award.find(params[:id])
    end



    def export_list_params
      params.require(:export_list).permit(:user_id, awards_attributes: [:title, :abbreviation, :awarded_for, :definition, :time_period, :award_date, :export_list_id])
    end
end
