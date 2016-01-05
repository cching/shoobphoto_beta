class ExportListItemsController < ApplicationController
  require "rubygems"
   require 'zip'
 require "open-uri"

  def clean_up
    @first = params[:students]
  end

  def add_student
    @student = Student.find(params[:student_id])
    current_user.students << @student
  end

  def remove_student
    @student = Student.find(params[:student_id])
    current_user.students.delete(@student)
  end

  def select_all
    @ids = params[:students]
    @ids.each do |student_id|
      unless current_user.students.exists?(Student.find(student_id))
          current_user.students << Student.find(student_id)
      end
    end
  end

  def deselect_all
    @ids = params[:students]
    @ids.each do |student_id|
      current_user.students.delete(Student.find(student_id))
    end
  end

  def students
    if current_user
    @school = current_user.school
    @students = Student.searching(@school.id, params[:first_name], params[:last_name], params[:grade], params[:teacher], params[:student_id]).paginate(:per_page => 25,:page => params[:page])

    @image = @school.packages.where("name like ?", "%Fall%").last
  else
    redirect_to new_user_session_path
  end
  end

  def clear_students
    @ids = current_user.students.pluck(:id)
    current_user.students = []

    respond_to :js
  end

  def searches
    @search = current_user.students.search(params[:q])

    if params[:q].nil?
      @students = @search.result.order(:teacher).order(:last_name)
    else
      @students = @search.result
    end

    respond_to do |format|
      format.js
    end
  end

  def batch
    @operation = params[:operation].to_s
    @types = Type.all.order(:name)
    @first = current_user.students.first(25)

    if current_user.students.any?
    if @operation == 'awards'
      redirect_to export_searches_path, format: 'js'
    else
    bucket = AWS::S3::Bucket.new('shoobphoto')
    @school = School.find(params[:school_id])
    @package = @school.packages.where("name like ?", "%Fall%").last
      current_user.students.each do |student|
        image = @package.student_images.where(:student_id => student.id)
        if image.any?
          unless AWS::S3::S3Object.new(bucket, "images/#{image.last.folder}/#{image.last.image_file_name}.jpg").exists?
            current_user.students.delete(student)
          end
        end
      end

      
    end
  end
  end

  def zip
    @first = current_user.students.first(25)
    @package = Package.find(params[:package])
    bucket = AWS::S3::Bucket.new('shoobphoto')
      t = Tempfile.new("my-temp-filename-#{Time.now}")
      Zip::OutputStream.open(t.path) do |z|
          current_user.students.each do |student|
            image = @package.student_images.where(:student_id => student.id)
              title = "#{student.last_name}_#{student.first_name}.jpg"
              z.put_next_entry("images/#{title}")
              s3object = AWS::S3::S3Object.new(bucket, "images/#{image.last.folder}/#{image.last.image_file_name}.jpg")
              url1 = s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
              url1_data = open(url1)
              z.print IO.read(url1_data)
        end
      end

          send_file t.path, :type => 'application/zip',
                                 :x_sendfile => true,
                                 :filename => "StudentImages.zip"                
          t.close

          @left = current_user.students.pluck(:id) - @first.map(&:id)
          current_user.students = []
          current_user.students << Student.find(@left)
  end

  def new
    @student = Student.new
    @image = Package.find(params[:package])
    @school = School.find(params[:school])

    respond_to :js
  end

  def delete
    @student = Student.find(params[:id])
    
    @student.delete

    respond_to :js
  end

  def create
    @student = Student.new(student_params)
    @image = Package.find(params[:package])


        image = @student.student_images.new(:package_id => @image.id)
      
      image.image = params[:image]
      image.save

    @student.id_only = true
    
  @student.save
    respond_to do |format|
      format.js { render 'create'}

    end
  end
 

  def show
    @student = Student.find(params[:id])
    @package = Package.find(params[:image])
    @image = @package.student_images.where(:student_id => params[:id]).last

    @nodelete = @student.carts.map { |c| true if c.orders.any? }.any?

  end

  def download
  @image = Package.find(params[:image_id])
  @student = Student.find(params[:student_id])
  data = open("#{@image.student_images.where(:student_id => @student.id).last.image.url}")
  send_data data.read, filename: "#{@student.last_name}_#{@student.first_name}.jpg", type: "image/jpeg", :x_sendfile => true

  end

  def update
    @student = Student.find(params[:id])
    @student.update(student_params)
    @package = Package.find(params[:package])
    image = @package.student_images.where(:student_id => params[:id]).last


    if image.nil?
        image = @student.student_images.create(:package_id => @package.id)
    end

    if params[:image].present?
      image.image = params[:image]
      image.save
    end
    respond_to :js
  end


 def remove
  @student = Student.find(params[:id])
  current_user.user_students.where(:student_id => @student.id).destroy_all

 end

  def schools
    @schools = School.all.order(:name)
    respond_to :js
  end

  def school_user
    @school = School.find(params[:id])
    @image = @school.packages.where("name like ?", "%Fall%").last
    @students = Student.searching(@school.id, params[:first_name], params[:last_name], params[:grade], params[:teacher], params[:student_id]).paginate(:per_page => 25,:page => params[:page])
  end

  def users
    @users = User.all
    respond_to :js
  end

  def types
    current_user.students = []
          @package = Package.find(params[:image])
          @image = @package.student_images.where(:student_id => params[:id]).last
          @school = School.find(params[:school])
     
    @types = Type.all.order(:name) if @image.image.exists?
    respond_to :js
  end
  
  def form

  student_ids = current_user.students.pluck(:id)


    @export_data = ExportData.new(( {}).merge({
      kind: 'print',
      type_id: params[:type_id],
      user_id: current_user.id
    }))

    if student_ids.count > 0
      current_user.students.each do |student|
      @export_data.export_data_students.new(:student_id => student.id)
    end
    else
      @export_data.export_data_students.new(:student_id => params[:id])
    end


    queued = @export_data.save 
    #&& ExportJob.new(@export_data.id, params[:package])
    
        redirect_to export_waiting_path(@export_data.id, params[:package], :format => 'pdf')
        current_user.students = []
  end

  
  def waiting
    @export_data = ExportData.find(params[:id])

    respond_to do |format|
    format.pdf do
      pdf = ExportPdf.new(@export_data, params[:package])
      send_data pdf.render, filename: "id_#{@export_data.id}",
                            type: "application/pdf",
                            disposition: "inline"
    end
  end

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
      params.require(:student).permit(:first_name, :last_name, :id_only, :grade, :school_id, :student_id, :grade, :image, :dob, :data1, :data2, :data3, :data4, student_images_attributes: [:image])
    end

end