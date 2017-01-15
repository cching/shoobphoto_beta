class Admin::UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_password, :update_password, :delete]

	  respond_to :html

	  before_action :require_admin
	  def require_admin
	    unless current_user.try(:admin)
	      redirect_to root_path
	    end
	  end

	def csv
	end

	def new
		@user = User.new
		respond_with(@user)
	end

	def delete
		@user.delete

		redirect_to admin_users_path
	end

	def edit_password
	end

	def update
    	@user.update(user_params)
    	redirect_to admin_users_path
  	end

  	def update_password
    	bool = @user.update(user_params)
    	if bool == true
    	redirect_to admin_users_path
    	else
    		redirect_to :back, notice: "Passwords do not match or isn't at least 6 characters."
    	end
  	end

	def index
		@users = User.all.order(:first_name)
	end

	def create
		@user = User.new(user_params)

    	if @user.save

	    	if @user.teacher?
	    		redirect_to sync_admin_user_path(@user)
	    	else
	    		redirect_to admin_users_path, notice: "User created."
	    	end
	    else
	    	render('new')
	    end
    end

    def sync
    	@user = User.find(params[:id])
    	@students = @user.school.students.where("teacher like ?", "%#{@user.last_name}%")

    	@students.each do |student|
    		student.update(:user_id => @user.id)
    	end
    end

	def edit
	end

	def import
    chunk = SmarterCSV.process(params[:file].tempfile, {:chunk_size => 2000, row_sep: :auto}) do |chunk|
      UserImport.perform_async(chunk)
    end
    redirect_to csv_admin_users_path, notice: "Users successfully imported."
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params[:user].permit(:first_name, :school_id, :last_name, :password, :password_confirmation, :school_admin, :principal, :parent, :secretary, :teacher, :email)
    end
end