class WebcamsController < ApplicationController
  helper :headshot
    def capture
      # do something
    end

    def show
    end

    def select
      @types = Type.all.order(:name)
      @school = current_user.school
    end

    def update_student
      @student = current_user.students.where(:webcam => true).last
      @student.update(:first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :teacher => params[:teacher], :grade => params[:grade], :data1 => params[:data1], :data2 => params[:data2], :data3 => params[:data3], :data4 => params[:data4])
    end

    def types
      @student = current_user.students.where(:webcam => true).last
      @export_data = ExportData.new(( {}).merge({
        kind: 'print',
        type_id: params[:id],
        user_id: current_user.id
        }))


        @export_data.export_data_students.new(:student_id => @student.id)
        @export_data.save 
        redirect_to waiting_path(@export_data.id, :format => 'pdf')
    end


    def waiting
      @export_data = ExportData.find(params[:id])
      respond_to do |format|
      format.pdf do
        pdf = WebcamExport.new(@export_data, Package.first.id)
        send_data pdf.render, filename: "id_#{@export_data.id}",
                              type: "application/pdf",
                              disposition: "inline" 
      end
    end
  end

    def newstudent
      respond_to :js
    end

    def refresh
      @image = File.join("/headshots", "#{current_user.students.where(:webcam => true).last.image_file_name}")
      respond_to :js

    end

    
end
