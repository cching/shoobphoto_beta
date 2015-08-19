class Admin::DashboardsController < ApplicationController
  before_action :require_admin


  def require_admin
    unless current_user.try(:admin)
      redirect_to root_path
    end
  end

  def index
  end

end
