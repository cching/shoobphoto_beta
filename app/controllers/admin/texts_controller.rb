class Admin::TextsController < ApplicationController
  before_action :require_admin

  def upload; end

  def import
    if params[:file]
      csv = params[:file].read
      CreateMMSFromCsvJob.perform_async(csv)

      redirect_to :back, alert: 'The CSV file is now being processed on Sidekiq.'
    else
      redirect_to :back, alert: 'No file is selected'
    end
  end

end