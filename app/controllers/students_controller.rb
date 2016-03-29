class StudentsController < ApplicationController
  require 'aws-sdk'
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def find_student
  end
 
  def findbyid 
    @school = School.find(params[:school])
    @students = @school.students.where("student_id = ?", "#{params[:student_id].gsub(/\s+/, "")}").where(:id_only => true)

    if @students.any? && (params[:student_id].gsub(/\s+/, "") != "" && params[:student_id] != nil)
      @student = @students.last
      respond_to :js
    else
      render :nothing => true
    end
  end

  def download
    @shoob_id = "#{params[:shoob_id].gsub(/\s+/, "").downcase}"
    if @shoob_id[4] == "1"
      @found_image = DownloadImage.where("lower(shoob_id) = ?", "#{@shoob_id}").where(:folder => "fall2015").last
    elsif @shoob_id[4] == "2"
      @found_image = DownloadImage.where("lower(shoob_id) = ?", "#{@shoob_id}").where(:folder => "spring2016").last
    elsif @shoob_id[4] == "3"
      @found_image = DownloadImage.where("lower(shoob_id) = ?", "#{@shoob_id}").where(:folder => "grad2016").last
    end
    unless @found_image.nil?
      @student = @found_image.student
      @ids = @student.download_images.pluck(:id)
      @images = DownloadImage.where(id: @ids)

      @images.each do |image|
        if @images.where(:package_id => image.package.id).where(:year => image.year).count > 1
          @ids = @ids - [@images.where(:package_id => image.package.id).where(:year => image.year).last.id]
        end
      end
      @images = DownloadImage.find(@ids - [@found_image.id]).sort_by {|x| x.year}.reverse
    end
  end

  def download_image
  @student = Student.find(params[:student])
  data = open("#{params[:url]}")
  send_data data.read, filename: "#{@student.last_name}_#{@student.first_name}.jpg", type: "image/jpeg", :x_sendfile => true

  end

  def final
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @student = @cart.students[params[:i].to_i]
    @price = 0
      @cart.order_packages.each do |package|
       @price = package.option.price(@student.school.id) + @price
      end

      @cart.order_packages.each do |opackage|
        if opackage.package.shippings.where(:school_id => Student.find(opackage.student_id).school.id).any?
        @price = @price + opackage.package.shippings.where(:school_id => Student.find(opackage.student_id).school.id).first.price
        elsif opackage.package.shippings.where(:school_id => nil).any?
        @price = @price + opackage.package.shippings.where(:school_id => nil).first.price
        end
        opackage.extras.each do |e|
        unless e.prices.first.try(:price).nil?
        @price = @price + e.prices.first.price
        end
      end 
      end

       @cart.update(:price => @price)
  end

  def update_cart
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @student = @cart.students[@cart.students.count - 1]
    @cart.order_packages.where(:student_id => @student.id).each do |o|
      o.extras.destroy_all
    end
    unless params[:order_package].nil?
    params[:order_package].each do |order_package, value| 
      o = OrderPackage.find(order_package.to_param)
      unless value[:extra_ids].nil?
      value[:extra_ids].each do |extra_id, value|
        value.each do |value|
        oextra = o.order_package_extras.create(:order_package_id => o.id)  
        oextra.update(:extra_id => value.to_param)
        end
      end
      end

      if value[:email_picture].nil?
        o.update(:email_picture => false)
      else
        o.update(:email_picture => true)
      end
    end
  end
  
    redirect_to student_final_path(@cart.cart_id, @cart.students.count - 1)
  end

  def review
    @cart = Cart.find_by_cart_id(params[:id])

    @student = @cart.students[params[:i].to_i]
    @opackages = @cart.order_packages.where(:student_id => @student.id).order(:id)
    @image_url = []

    bucket = AWS::S3::Bucket.new('shoobphoto')

    @opackages.each do |opackage|
      package = opackage.package
      image = package.student_images.where(:student_id => @student.id).last
      unless image.nil?
        unless image.image_file_name.nil? || @cart.id_supplied == false || image.image_file_name == ""
          if AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name.upcase}.jpg").exists?
            s3object = AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name.upcase}.jpg")
          else
            s3object = AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name.downcase}.jpg")
          end
        else
          s3object = AWS::S3::S3Object.new(bucket, "images/package_types/#{image.package.id}/#{image.package.image_file_name}") #do default image in col later
        end
      else
          s3object = AWS::S3::S3Object.new(bucket, "images/package_types/#{package.id}/#{package.image_file_name}")
      end
      @image_url << s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
    end 
  end

  def lessonbuilder
    redirect_to "www.lessonbuilder.shoobphoto.com"
  end

  def update
    @cart = Cart.find_by_cart_id(params[:id])
    @student = @cart.students[params[:i].to_i]

    @price = 0

    @cart.update(cart_params)

    @cart.order_packages.where(:student_id => @student.id).each do |package|
     @price = package.option.price(@student.school.id) + @price
    end

    @cart.order_packages.where(:student_id => @student.id).each do |opackage|
      package = opackage.package
      if package.shippings.where(:school_id => @cart.students[params[:i].to_i].school.id).any?
      @price = @price + package.shippings.where(:school_id => @cart.students[params[:i].to_i].school.id).first.price
      elsif package.shippings.where(:school_id => nil).any?
      @price = @price + package.shippings.where(:school_id => nil).first.price
      
      end
    end

    @cart.update(:price => @price)
    respond_to do |format|
        format.html { redirect_to student_review_path(:id => @cart.cart_id, :i => @cart.students.count - 1) }
    end
  end

  def select_package
    @cart = Cart.find_by_cart_id(params[:id])
    @student = @cart.students[params[:i].to_i]
    @opackages = @cart.order_packages.where(:student_id => @student.id).order(:id)
    @image_url = []

    bucket = AWS::S3::Bucket.new('shoobphoto')

    @opackages.each do |opackage|
      package = opackage.package
      image = package.student_images.where(:student_id => @student.id).last
      
      if package.id == 6
      @senior_url = []
      @senior_id = []
        unless image.nil? || @cart.id_supplied == false
          
          for attribute in ['url', 'url1', 'url2', 'url3', 'url4']
            unless image.attributes[attribute].nil? || image.attributes[attribute] == ""
              if AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.attributes[attribute].upcase}.jpg").exists?
                s3object = AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.attributes[attribute].upcase}.jpg")
              else
                s3object = AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.attributes[attribute].downcase}.jpg")
              end
              @senior_id << "#{image.attributes[attribute]}"
            else
              s3object = AWS::S3::S3Object.new(bucket, "images/package_types/#{package.id}/#{package.image_file_name}") #do default image in col later
               @senior_id << "default"
            end
             @senior_url << s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
            
          end
        else
          s3object = AWS::S3::S3Object.new(bucket, "images/package_types/#{package.id}/#{package.image_file_name}")
          @senior_url << s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
          @senior_id << "default"
        end
      end

      unless image.nil?
        unless image.image_file_name.nil? || @cart.id_supplied == false || image.image_file_name == ""
          if AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name.upcase}.jpg").exists?
            s3object = AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name.upcase}.jpg")
          else
            s3object = AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name.downcase}.jpg")
          end
        else
          s3object = AWS::S3::S3Object.new(bucket, "images/package_types/#{image.package.id}/#{image.package.image_file_name}") #do default image in col later
        end
      else
          s3object = AWS::S3::S3Object.new(bucket, "images/package_types/#{package.id}/#{package.image_file_name}")
      end

      @image_url << s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
    end 
  end 

  def packages
    @cart = Cart.find_by_cart_id(params[:id])
    @student = @cart.students[params[:i].to_i]
    @packages = @student.school.packages.order(:id)
    @image_url = []


    bucket = AWS::S3::Bucket.new('shoobphoto')

    @packages.each do |package|

      s3object = AWS::S3::S3Object.new(bucket, "images/package_types/#{package.id}/#{package.image_file_name}") #do default image in col later
      

      @image_url << s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)

    end


  end

  def input
    @school = School.find(params[:school])
    @i = params[:i]
    @cart_id = params[:cart]

    if params[:cart].to_i == 1 
      @student = @school.students.create(:first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :teacher => params[:teacher], :grade => params[:grade])
      @cart = @student.carts.create(:email => params[:email], :school_id => @school.id, :cart_id => (0...8).map { (65 + rand(26)).chr }.join)
    else
      @cart = Cart.find_by_cart_id(params[:cart])
      @cart.update(:id_supplied => params[:id_supplied])
      @student = @cart.students.create( :first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :school_id => @school.id, :teacher => params[:teacher], :grade => params[:grade])
    end
     

    redirect_to student_packages_path(@cart.cart_id, @i)
  end



  def find
    @school = School.find(params[:school])
    @i = (params[:i].nil? || params[:i] == "") ?  0 : params[:i]
    @cart_id = (params[:cart].nil? || params[:cart] == "") ?  1 : params[:cart]
    cookies[:user_email] = { :value => "#{params[:email]}", :expires => 5.years.from_now}


    if (params[:student_id].nil? || params[:student_id].strip == "")

      if params[:first_name].nil? || params[:last_name].nil?
        student = []
      else
      student = @school.students.where("lower(first_name) like ? and lower(last_name) like ?", "%#{params[:first_name].downcase}%", "%#{params[:last_name].downcase}%")
      
      end
      if student.count > 0
        @student = student.last

        if @cart_id.to_i == 1
          @cart = @student.carts.create(:cart_id => (0...8).map { (65 + rand(26)).chr }.join, :id_supplied => false, :school_id => @school.id, :email => params[:email])
        else
          @cart = Cart.find_by_cart_id(params[:cart])
          @cart.cart_students.create(:student_id => @student.id)
        end
        respond_to do |format|
            format.html { redirect_to student_packages_path(@cart.cart_id, @cart.students.count - 1) }
        end
      else
          respond_to do |format|
            format.js
            format.html { redirect_to student_input_path(@school.id, @cart_id, @i, :first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :school_id => @school.id, :teacher => params[:student_teacher], :grade => params[:grade], :email => params[:email], :id_supplied => "false") }
          end
      end

    else
      student = @school.students.where("lower(first_name) like ? and lower(last_name) like ? and student_id = ? and id_only = ?", "%#{params[:first_name].downcase}%", "%#{params[:last_name].downcase}%", "#{params[:student_id]}", "true")
       
    
      if student.count > 0
        @student = student.last
          if @cart_id.to_i == 1
            @cart = @student.carts.create(:school_id => @school.id, :email => params[:email])
            @cart.cart_id = (0...8).map { (65 + rand(26)).chr }.join
            @cart.save
          else
            @cart = Cart.find_by_cart_id(params[:cart])
            @cart.cart_students.create(:student_id => @student.id)
          end
          respond_to do |format|
              format.html { redirect_to student_packages_path(@cart.cart_id, @cart.students.count - 1) }
          end
      else ## check for dob, then redirect if none found
          respond_to do |format|
            format.js
            format.html { redirect_to student_input_path(@school.id, @cart_id, @i, :first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :school_id => @school.id, :teacher => params[:student_teacher], :dob => @dob, :grade => params[:grade], :email => params[:email], :id_supplied => "true") }
          end
      end
    end
  end

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
  end

  def schools
    @schools = School.all

    @cart = params[:cart_id] unless params[:cart_id].nil?
    @i = params[:i] unless params[:i].nil?
  end

  def cart
    @student = Student.find(params[:id])
    unless Cart.where(:student_id => @student.id).where(:purchased => false).last.nil?
          @cart = Cart.where(:student_id => @student.id).where(:purchased => false).last
      else
        @cart = @student.carts.create
        @cart.cart_id = (0...8).map { (65 + rand(26)).chr }.join
        @cart.save
      end

    redirect_to student_packages_path(@cart.cart_id)
  end

  def school_find
    @schools = SchoolType.where(params[:school_types]).last.schools.order(:name)
    @cart = params[:cart_id] unless params[:cart_id].nil?
    @i = params[:i] unless params[:i].nil?
    respond_to do |format|
      format.js
    end
  end

  def search
    unless params[:school].nil?
    @school = School.find(params[:school][:id])
    else
      @school = School.first
    end
    @i = params[:i] unless params[:i].nil?
    @cart = params[:cart] unless params[:cart].nil?

  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new

 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find_by_student_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:first_name, :last_name, :student_id, :grade, :cart, :dob, :teacher)
    end

    def cart_params
      params.require(:cart).permit(order_packages_attributes: [:package_id, :option_id, :id, :extra_ids => [], extras_attributes: [:id, :name]])
    end

    def school_params
        params.require(:school_types).permit(:id, :name)
    end
end
