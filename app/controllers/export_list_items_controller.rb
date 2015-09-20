class ExportListItemsController < ApplicationController

  def students
    if current_user
    @school = current_user.school
    @students = @school.students.order(:last_name).paginate(:page => params[:page], :per_page => 100)

    @image = @school.packages.where("name like ?", "%Fall%").last
  else
    redirect_to new_user_session_path
  end
  end

  def types
    @types = Type.all.order(:name)

    respond_to :js
  end
  
  def form
    
    @export_data = ExportData.new(( {}).merge({
      kind: 'print',
      type_id: params[:type_id],
      user_id: current_user.id
    }))

    @export_data.export_data_students.new(:student_id => params[:id])


      queued = @export_data.save && ExportJob.new(@export_data.id, current_user.school.packages.where("name like ?", "%Fall%").last)

      redirect_to "/export/waiting?export_data_id=#{@export_data.id}"

  end

  
  def waiting
    @pending = false
    params[:export_data_id] = params[:export_data_id].to_i

    @export_data = ExportData.find(params[:export_data_id])
    send_file(
         "#{Rails.root}/tmp/#{@export_data.id}.#{@export_data.format}",
        filename: "#{@export_data.id}.#{@export_data.format}",
        type: "#{@export_data.file_content_type}")
  end

  def upload
    if request.post?
      if params[:upload][:file].respond_to?(:read)
        identifiers = params[:upload][:file].read.split("\n")
        if school = School.where(id: params[:upload][:school_id].to_i).first
          student_ids = school.students.where(student_id: identifiers).pluck(:id)
          if student_ids.any?
            insert_student_ids_into_export_list_items student_ids
            render json: {
              page: ERB::Util.html_escape(render_to_string('index'))
            }.merge(export_list_count_and_styles)
          else
            @error = 'Could not find any students with the given identifiers.'
          end
        else
          @error = 'Could not find selected school.'
        end
      else
        @error = 'Could not read file.'
      end
      if @error
        @error = "Upload failed. #{@error}"
        render json: {
          success: false,
          page: ERB::Util.html_escape(render_to_string('upload'))
        }
      end
    end
  end
  
  def select
  end
  
  def view_request
    @request = params[:view_request]
    render 'export_list_items/view_request'
  end
  
  def clear
    current_user.export_list_items.delete_all
    render nothing: true
  end
  
  def toggle
    list_items = current_user.export_list_items.where(student_id: params[:student_id])
    removed = false
    if list_items.any?
      list_items.destroy_all
      removed = true
    else
      current_user.export_list_students << Student.where(id: params[:student_id])
    end
    render json: export_list_count_and_styles.merge(removed: removed)
  end
  
  def find_collection
    coll = current_user.export_list_students.includes(:users).with_permissions_to(:show)
    coll = coll.order('students.last_name').limit(offset_amount).offset(params[:offset].to_i)
    if params[:order].present? &&
      (match = /(\w+)\.(\w+) (asc|desc)/.match(params[:order])) &&
      match[1] == 'students' &&
      Student.column_names.include?(match[2])
        coll = coll.reorder(params[:order])
    end
    coll
  end

end