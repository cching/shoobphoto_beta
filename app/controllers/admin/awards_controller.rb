class Admin::AwardsController < ApplicationController
  before_action :require_admin


	  def require_admin
	    unless current_user.try(:admin)
	      redirect_to root_path
	    end
	  end

	def index
	end

	def notprocessed
		@award = AwardInfo.find(params[:id])
		@award.update(:processed => false)
	

		respond_to do |format|
			format.js
		end
	end

	def export
		e = Export.create
		AwardExport.perform_async(e.id)
		redirect_to admin_awards_path, notice: "Generating award CSV. Please refresh in a few minutes."
	end

	def processed
		@award = AwardInfo.find(params[:id])
		@award.update(:processed => true)

		respond_to do |format|
			format.js
		end
	end
end