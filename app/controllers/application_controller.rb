class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter :set_nav_links


  	def after_sign_in_path_for(resource)
  		if current_user.try(:admin)
        admin_dashboards_path
      elsif current_user.try(:parent)
        yearbooks_path
      else
        export_students_path
      end
	end

	def set_nav_links
	    @nav_links = NavLink.order(:position).roots
	end

  def headshot_post_save(file_path)
    @headshot_photo = HeadshotPhoto.last
    @headshot_photo.update(:user_id => current_user.id, :image_file_name => file_path)
    student = current_user.students.create(:webcam => true, :school_id => current_user.school.id)
    student.image = File.new(file_path)
    student.save

  end 

end
