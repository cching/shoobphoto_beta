class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_nav_links
  	def after_sign_in_path_for(resource)
  		if current_user.try(:admin)
        admin_dashboards_path
      else
        export_students_path
      end
	end

	def set_nav_links
	    @nav_links = NavLink.order(:position).roots
	end

end
