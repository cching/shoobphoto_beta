class Admin::TextsController < ApplicationController
  before_action :require_admin
  
  def upload
  end

  def import
    if params[:file]
      csv = CSV.parse(params[:file].read, headers: true)
      csv.each do |row|
        data = row.to_hash
        SendText.perform_async(data['phone'], data['shoob_id'], data['folder'])
      end
      redirect_to :back, alert: 'The CSV file is now being processed on Sidekiq.'
    else
      redirect_to :back, alert: 'No file selected'
    end
  end
end