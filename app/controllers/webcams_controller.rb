class WebcamsController < ApplicationController
require 'base64'
    def capture
      # do something
      render :layout => "webcam"
    end

    def save_image
      image = params[:capture][:image]
      File.open("#{Rails.root}/public/path_you_want_to_image/image_name.png", 'wb') do |f|
        f.write(Base64.decode64(image))
      end
      # Or use paperclip to save image for a model instead!!
    end
end
