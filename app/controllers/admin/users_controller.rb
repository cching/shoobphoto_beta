class Admin::UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :destroy]

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

	def index
		@users = User.all.order(:last_name)
	end

	def create
		@user = User.new(user_params)
    	@user.save
    	redirect_to admin_users_path, notice: "User created."
    end

	def edit
	end

	def import
    chunk = SmarterCSV.process(params[:file].tempfile, {:chunk_size => 500, row_sep: :auto}) do |chunk|
      UserImport.perform_async(chunk)
    end
    redirect_to csv_admin_users_path, notice: "Users successfully imported."
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params[:user].permit(:first_name, :school_id, :last_name, :password, :password_confirmation, :school_admin, :parent, :secretary, :teacher, :email)
    end
end