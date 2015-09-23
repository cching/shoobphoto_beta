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

  def search
    @school = School.find(params[:school])
    @image = @school.packages.where("name like ?", "%Fall%").last
    @students = @school.students
    @students = @students.where("lower(first_name) like ?", "%#{params[:first_name].downcase}%") unless params[:first_name].nil?
    @students = @students.where("lower(last_name) like ?", "%#{params[:last_name].downcase}%") unless params[:last_name].nil?
    @students = @students.paginate(:page => params[:page], :per_page => 100)

    respond_to :js
  end

  def new
    @student = Student.new
    @image = Package.find(params[:package])
    @school = School.find(params[:school])

    respond_to :js
  end

  def create
    @student = Student.new(student_params)
    @student.id = Student.last.id + 1
    @image = Package.find(params[:package])


        id = StudentImage.last.id + 1
        image = @student.student_images.new(:id => id, :package_id => @image.id)
      
      image.image = params[:image]
      image.save
    
  @student.save
    respond_to do |format|
      format.js { render 'create'}
      format.html

    end
  end


  def show
    @student = Student.find(params[:id])
    @package = Package.find(params[:image])
    bucket = AWS::S3::Bucket.new('shoobphoto')
    @image = @package.student_images.where(:student_id => params[:id]).last

  end

  def update
    @student = Student.find(params[:id])
    @student.update(student_params)
    @package = Package.find(params[:package])
    image = @package.student_images.where(:student_id => params[:id]).last


    if image.nil?
        id = StudentImage.last.id + 1
        image = @student.student_images.create(:id => id, :package_id => @package.id)
    end

    if params[:image].present?
      image.image = params[:image]
      image.save
    end
    respond_to :js
  end

  def schools
    @schools = School.all.order(:name)
    respond_to :js
  end

  def school_user
    @school = School.find(params[:id])
    @image = @school.packages.where("name like ?", "%Fall%").last
    @students = @school.students.order(:last_name).paginate(:page => params[:page], :per_page => 100)
  end

  def users
    @users = User.all
    respond_to :js
  end

  def types
      bucket = AWS::S3::Bucket.new('shoobphoto')
          @package = Package.find(params[:image])
          @image = @package.student_images.where(:student_id => params[:id]).last
     
    @types = Type.all.order(:name) if @image.image.exists?
    respond_to :js
  end
  
  def form
    
    @export_data = ExportData.new(( {}).merge({
      kind: 'print',
      type_id: params[:type_id],
      user_id: current_user.id
    }))

    @export_data.export_data_students.new(:student_id => params[:id])

    queued = @export_data.save && ExportJob.new(@export_data.id, params[:package])

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

  private

  def student_params
      params.require(:student).permit(:first_name, :last_name, :grade, :school_id, :image, :dob, student_images_attributes: [:image])
    end

end