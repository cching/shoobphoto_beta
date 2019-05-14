class CreateMMSFromCsvJob
  include Sidekiq::Worker
  sidekiq_options queue: 'package_import'

  def perform(csv)
    # TODO: create logic for error handling
    SMSService.send_mms_from_csv(csv)
  end


end