class WebcamsController < ApplicationController
  helper :headshot
    def capture
      # do something
    end

    def select
      @types = Type.all.order(:name)
      @school = current_user.school
    end

    def student
    end

    def newstudent
      sleep 4
      @image = current_user.students.where(:webcam => true).last.image.url
      respond_to :js
    end

    
end
