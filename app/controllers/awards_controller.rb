class AwardsController < ApplicationController
  before_action :set_award, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if current_user
    else
      redirect_to new_user_session_path
    end
  end

  def show
    respond_with(@award)
  end

  def new
    if current_user
    @export_list = ExportList.create(:submitted => false)
    @export_list.save
    @export_list.update(:uniq_id => SecureRandom.hex(8))
    redirect_to edit_award_path(@export_list.id)
    else
      redirect_to new_user_session_path
    end
  end

  def edit
  end

  def create
    @export_list = ExportList.new(export_list_params)
    

    redirect_to export_awards_path(@export_list.uniq_id)
  end

  def update
    @export_list.update(export_list_params)
    redirect_to export_awards_path(@export_list.uniq_id)
  end

  def destroy
    @award.destroy
    respond_with(@award)
  end

  private
    def set_award
      @export_list = ExportList.find(params[:id])
    end



    def export_list_params
      params.require(:export_list).permit(:user_id, awards_attributes: [:title, :abbreviation, :awarded_for, :definition, :time_period, :award_date, :export_list_id, :recieve_by, :id])
    end
end
