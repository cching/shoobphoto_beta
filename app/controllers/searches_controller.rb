class SearchesController < ApplicationController
  def new
    @search = Search.new
  end
  
  def create
    @search = Search.create!(search_params)
    redirect_to @search
  end
  
  def show
    @search = Search.find(params[:id])
  end

  private

  def search_params
      params.require(:search).permit(:first_name, :last_name, :school_id, :student_last_name, :student_first_name, :processed, :billing_city, :city, :billing_address, :address, :billing_zip, :zip, :phone, :email, :card_type)
    end
end
