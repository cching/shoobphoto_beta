class Admin::AwardsController < ApplicationController
  before_action :set_award, only: [:show, :edit, :update, :destroy]
  before_action :require_admin


	  def require_admin
	    unless current_user.try(:admin)
	      redirect_to root_path
	    end
	  end


	def notprocessed
		@award = AwardInfo.find(params[:id])
		@award.update(:processed => false)
	

		respond_to do |format|
			format.js
		end
	end

	def list
	end

	def export
		e = Export.create
		AwardExport.perform_async(e.id)
		redirect_to list_admin_awards_path, notice: "Generating award CSV. Please refresh in a few minutes."
	end 

	def processed
		@award = AwardInfo.find(params[:id])
		@award.update(:processed => true)

		respond_to do |format|
			format.js
		end
	end

  # GET /awards
  # GET /awards.json
  def index
    @awards = Award.all
  end

  # GET /awards/1
  # GET /awards/1.json
  def show
  end

  # GET /awards/new
  def new
    @award = Award.new
  end

  # GET /awards/1/edit
  def edit
  end

  # POST /awards
  # POST /awards.json
  def create
    @award = Award.new(award_params)

    respond_to do |format|
      if @award.save
        format.html { redirect_to admin_awards_path, notice: 'Award was successfully created.' }
        format.json { render :show, status: :created, location: @award }
      else
        format.html { render :new }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /awards/1
  # PATCH/PUT /awards/1.json
  def update
    respond_to do |format|
      if @award.update(award_params)
        format.html { redirect_to admin_awards_path, notice: 'Award was successfully updated.' }
        format.json { render :show, status: :ok, location: @award }
      else
        format.html { render :edit }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /awards/1
  # DELETE /awards/1.json
  def destroy
    @award.destroy
    respond_to do |format|
      format.html { redirect_to admin_awards_path, notice: 'Award was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_award
      @award = Award.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def award_params
      params.require(:award).permit(:title, :trait_definition, :abbreviation, :image, :add_period, :add_date, :add_awarded_for, :add_definition, :school_id)
    end
end
