class StudentsController < ApplicationController
  require 'aws-sdk'
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def final
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @price = 0
      @cart.order_packages.each do |package|
       @price = package.option.price + @price
      end

      @cart.order_packages.each do |opackage|
        if opackage.package.shippings.where(:school_id => Student.find(opackage.student_id).school.id).any?
        @price = @price + opackage.package.shippings.where(:school_id => Student.find(opackage.student_id).school.id).first.price
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

  def update
    @cart = Cart.find_by_cart_id(params[:id])
    @student = @cart.students[params[:i].to_i]

    @price = 0

    @cart.update(cart_params)

    @cart.order_packages.where(:student_id => @student.id).each do |package|
     @price = package.option.price + @price
    end

    @cart.order_packages.where(:student_id => @student.id).each do |opackage|
      package = opackage.package
      if package.shippings.where(:school_id => @cart.students[params[:i].to_i].school.id).any?
      @price = @price + package.shippings.where(:school_id => @cart.students[params[:i].to_i].school.id).first.price
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
    id = Student.last.id + 1 
    if params[:cart].to_i == 1 
      @student = @school.students.create(:id => id, :first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :teacher => params[:teacher], :grade => params[:grade], :dob => params[:dob])
      @cart = @student.carts.create(:school_id => @school.id, :cart_id => (0...8).map { (65 + rand(26)).chr }.join)
    else
      @cart = Cart.find_by_cart_id(params[:cart])
      @student = @cart.students.create(:id => id, :first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :school_id => @school.id, :teacher => params[:teacher], :grade => params[:grade], :dob => params[:dob])

    end
     

    redirect_to student_packages_path(@cart.cart_id, @i)
  end



  def find
    @school = School.find(params[:school])
    @i = (params[:i].nil? || params[:i] == "") ?  0 : params[:i]
    @cart_id = (params[:cart].nil? || params[:cart] == "") ?  1 : params[:cart]
    @dob = "#{params[:date][:year].to_s}/#{params[:date][:month].to_s}/#{params[:date][:day].to_s}"
    if params[:student_id].nil? || params[:student_id] == ""
      student = @school.students.where("lower(first_name) like ? and lower(last_name) like ?", "%#{params[:first_name].downcase}%", "%#{params[:last_name].downcase}%")

      if student.count > 0
        @student = student.last

        if @cart_id.to_i == 1
          @cart = @student.carts.create(:cart_id => (0...8).map { (65 + rand(26)).chr }.join, :id_supplied => false, :school_id => @school.id)
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
            format.html { redirect_to student_input_path(@school.id, @cart_id, @i, :first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :school_id => @school.id, :teacher => params[:student_teacher], :grade => params[:grade], :dob => @dob) }
          end
      end

    else
      student = @school.students.where("lower(first_name) like ? and lower(last_name) like ? and student_id = ?", "%#{params[:first_name].downcase}%", "%#{params[:last_name].downcase}%", "#{params[:student_id]}")
      if student.count > 0
        @student = student.last
          if @cart_id.to_i == 1
            @cart = @student.carts.create(:school_id => @school.id)
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
            format.html { redirect_to student_input_path(@school.id, @cart_id, @i, :first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :school_id => @school.id, :teacher => params[:student_teacher], :dob => @dob, :grade => params[:grade], :dob => @dob) }
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
    @school = School.find(params[:school][:id])
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
