ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => 'smtp.mailgun.org',
  :port => 587,
  :domain => 'shoobphoto.com',
  :authentication => 'plain',
  :user_name => 'postmaster@mg.shoobphoto.com',
  :password => ENV['EMAIL_PASSWORD']
} 
 