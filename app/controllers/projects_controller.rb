class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html


  def show
    respond_with(@project)
  end

  def new
    @project = Project.new
    respond_with(@project)
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    @project.save
      if @project.save
        redirect_to new_porders_path(@project.id) 
      else
        render 'new'
      end
    
  end

  def update 
    @project.update(project_params)
    respond_with(@project)
  end

  def destroy
    @project.destroy
    respond_with(@project)
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:school, :email, :first_name, :last_name, :position, :phone, :delivery, :flexible, :project_prints_attributes => [:id, :project_id, :print_id, :quantity, :description, :file, :image, :delivery, :flexible, :print_size_id, :print_type_id])
    end
end
