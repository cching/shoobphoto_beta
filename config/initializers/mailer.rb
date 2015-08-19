ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => 'shoobphoto.com',
  :authentication => 'plain',
  :user_name => 'info@shoobphoto.com',
  :password => 'can40d2011'
}
