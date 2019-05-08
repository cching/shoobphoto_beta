class Admin::TextsController < ApplicationController
  before_action :require_admin
  
  def upload
  end

  def import
    # TODO: rather move the logic for single service logic so the loop is performed asynchronously
    if params[:file]
      csv = CSV.parse(params[:file].read, headers: true)
      csv.each do |row|
        data = row.to_hash
        puts data
        SendText.perform_async(data['phone'], data['shoob_id'], data['image_name'], data['folder'], data['message'])
      end
      redirect_to :back, alert: 'The CSV file is now being processed on Sidekiq.'
    else
      redirect_to :back, alert: 'No file selected'
    end
  end
end