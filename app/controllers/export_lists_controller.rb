class ExportListsController < ApplicationController
  before_action :set_export_list, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @export_lists = ExportList.all
    respond_with(@export_lists)
  end

  def show 
    respond_with(@export_list)
  end

  def new
    @export_list = ExportList.find(params[:export_list])

    current_user.user_students.each do |ustudent|
      @export_list.export_list_students.create(:student_id => ustudent.student_id, :award_id => ustudent.award_id)
    end
    ListExport.perform_async(@export_list.id)
  end

  def edit
  end

  def create
    
  end

  def update
    @export_list.update(export_list_params)
    respond_with(@export_list)
  end

  def destroy
    @export_list.destroy
    respond_with(@export_list)
  end

  private
    def set_export_list
      @export_list = ExportList.find(params[:id])
    end

    def export_list_params
            params.require(:export_list).permit(:name, :school, :date, :delivery, :title, :data, :school_id)

    end
end
