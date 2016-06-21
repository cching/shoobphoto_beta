class StudentsController < ApplicationController
  require 'aws-sdk'
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def find_student
  end

  def update_senior_portraits
    @image = params[:url]
    @index = params[:index]
    @id = params[:i]

    respond_to do |format|
      format.js
    end
  end

  def senior_portraits
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @student = @cart.students[params[:i].to_i]
    @i = params[:i]
    bucket = AWS::S3::Bucket.new('shoobphoto')
      @opackage = @cart.order_packages.where(:student_id => @student.id).joins(:package).where("lower(packages.name) like ?", "%senior%").last
      image = @opackage.package.student_images.where(:student_id => @student.id).last

          @senior_url = []
          @senior_id = []
            unless image.nil? || @cart.id_supplied == false
              
              for attribute in ['url', 'url1', 'url2', 'url3', 'url4']
                unless image.attributes[attribute].nil? || image.attributes[attribute] == ""

                  @senior_id << "#{image.attributes[attribute]}"

                  s3object = AWS::S3::S3Object.new(bucket, "images/watermarks/#{image.id}/watermark/#{image.attributes[attribute]}.jpg")

                    if s3object.exists?

                        @senior_url << s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
            
                  end
                else
                   @senior_id << "default"
                end
                
              end
            else
              s3object = AWS::S3::S3Object.new(bucket, "images/package_types/#{package.id}/#{package.image_file_name}")
              @senior_url << s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
              @senior_id << "default"
            end # end unless
         
         # have redirect here to final if no senior images exist. add redirect on previous page
  end

  def add_option
    @op = OrderPackage.find(params[:order_package_id])
    @i = params[:i]
    @cart = @op.cart
    @option = Option.find(params[:option_id])
    @bool =[]

    @op.options << @option
    @op.cart.order_packages.each do |opackage|
      if opackage.options.any?
        @bool << true
      else
        @bool << false
      end
    end 
  end

  def remove_option
    @op = OrderPackage.find(params[:order_package_id])
    @i = params[:i]
    @option = Option.find(params[:option_id])
    @bool = []

    @op.options.delete(@option)

    @op.cart.order_packages.each do |opackage|
      if opackage.options.any?
        @bool << true
      else
        @bool << false
      end
    end
  end

  def remove_package
    @cart = Cart.find_by_cart_id(params[:id])
    @cart.order_packages.where(:download_image_id => params[:did]).last.delete
    @i = params[:did]

    @opackages = @cart.order_packages.pluck(:download_image_id)

  end

  def purchase
    @i = params[:i]
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @dimage = DownloadImage.find(params[:image])
    @student = Student.find(params[:id])
    if @dimage.package_id.nil?
      id = 253
    else
      id = @dimage.package_id
    end
   # @cart.order_packages.create(:package_id => id, :student_id => @student.id, :download_image_id => @dimage.id)
   @package = Package.find(id)

   if OrderPackage.where(:student_id => @student.id).where(:cart_id => @cart.id).where(:download_image_id => @dimage.id).any?
    @opackage = OrderPackage.where(:student_id => @student.id).where(:cart_id => @cart.id).where(:download_image_id => @dimage.id).last
    else
    @opackage = @package.order_packages.create(:student_id => @student.id, :cart_id => @cart.id, :download_image_id => @dimage.id)
    end
    #@cart.order_packages.last.update(:option_id => Package.find(id).options.first.id)
    @image_url = []


  end

  def create_cart
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
      @cart = @student.carts.create(:cart_id => (0...8).map { (65 + rand(26)).chr }.join, :id_supplied => false, :school_id => @student.school.id, :shoob_id => @shoob_id)
      redirect_to student_download_path(:shoob_id => @shoob_id, :cart_id => @cart.cart_id)
    else
      redirect_to :back, alert: "We've had trouble finding your images with ID #{@shoob_id}. Please contact us if you have trouble finding your images."
    end
  end
 
  def findbyid 
    @school = School.find(params[:school])
    @students = @school.students.where("student_id = ?", "#{params[:student_id].gsub(/\s+/, "")}").where(:id_only => true)

    if @students.any? && (params[:student_id].gsub(/\s+/, "") != "" && params[:student_id] != nil)
      @student = @students.last
      RenderWatermark.perform_async(@student.id)
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
        if @images.where(:folder => image.folder).where(:year => image.year).count > 1
          @ids = @ids - [@images.where(:folder => image.folder).where(:year => image.year).first.id]
          @images = DownloadImage.where(id: @ids)
        end

        if @images.where(:folder => @found_image.folder).where(:year => @found_image.year).count > 0
          @ids = @ids - [@images.where(:folder => @found_image.folder).where(:year => @found_image.year).first.id]
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
        package.options.each do |option|
           @price = option.price(@student.school.id) + @price
        end
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

  def previous_images
    @i = params[:i]

    @cart = Cart.find_by_cart_id(params[:id])
    @student = @cart.students[params[:i].to_i]
    @ids = @student.download_images.pluck(:id) 

    if @cart.order_packages.where(:student_id => @student.id).joins(:package).where("lower(packages.name) like ?", "%fall%").any?
      @ids = @ids - @student.download_images.where(:folder => "fall2015").pluck(:id)
    end

    if @cart.order_packages.where(:student_id => @student.id).joins(:package).where("lower(packages.name) like ?", "%spring%").any?
      @ids = @ids - @student.download_images.where(:folder => "spring2016").pluck(:id)
    end

    if @cart.order_packages.where(:student_id => @student.id).joins(:package).where("lower(packages.name) like ?", "%senior%").any?
      @ids = @ids - @student.download_images.where(:folder => "seniors2016").pluck(:id)
    end
      
      @images = DownloadImage.where(id: @ids)

      @images.each do |image|
        if image.image_file_name.nil?
          image.update(:image_file_name => image.try(:url).downcase)
        end
        if image.year.nil?
          image.update(:year => image.folder[-4..-1])
        end

        if image.folder.include? "senior"
          for attribute in ['url', 'url1', 'url2', 'url3', 'url4']
            while @images.where(:url => attribute).count > 1
              @ids = @ids - [@images.where(:url => attribute).first.id]
              @images = DownloadImage.where(id: @ids)
            end
            unless image.image.exists?
              image.update(:image_file_name => image.image_file_name.downcase)
            end

          end
        else
          while @images.where(:folder => image.folder).where(:year => image.year).count > 1
            @ids = @ids - [@images.where(:folder => image.folder).where(:year => image.year).first.id]
            @images = DownloadImage.where(id: @ids)
          end
        end
      end
      @images = DownloadImage.find(@ids).sort_by {|x| x.year}.reverse
  end

  def update_cart
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @student = @cart.students[@cart.students.count - 1]
     
      if @cart.students[params[:i].to_i].download_images.any? && @cart.id_supplied?
        redirect_to previous_images_path(@cart.cart_id, @cart.students.count - 1)
      else
        redirect_to student_final_path(@cart.cart_id, @cart.students.count - 1)
      end
    
  end

  def add_options
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @i = params[:i].to_i
    @student = @cart.students[@i]
    @option = Option.find(params[:option_id])
    @op = OrderPackage.find(params[:op_id])
    
    @op.extras = []
    unless params[:extra_ids].nil?
    params[:extra_ids].each do |extra_id, value| 
      value.each do |value|
        oextra = @op.order_package_extras.create(:option_id => @option.id)  
        oextra.update(:extra_id => value.to_param)
      end
    end
    end

  end

  def review
    @cart = Cart.find_by_cart_id(params[:id])
    @i = params[:i]

    @student = @cart.students[params[:i].to_i]
    @opackages = @cart.order_packages.where(:student_id => @student.id).order(:id)

  end

  def update
    @cart = Cart.find_by_cart_id(params[:id])
    @student = @cart.students[params[:i].to_i]

    @price = 0


    @cart.order_packages.each do |package|
     package.options.each do |option|
      @price = option.price(@student.school.id) + @price
     end
    end

    @cart.order_packages.each do |opackage|
      package = opackage.package
      if package.shippings.where(:school_id => @cart.students[params[:i].to_i].school.id).any?
      @price = @price + package.shippings.where(:school_id => @cart.students[params[:i].to_i].school.id).first.price
      elsif package.shippings.where(:school_id => nil).any?
      @price = @price + package.shippings.where(:school_id => nil).first.price
      
      end
    end

    @cart.update(:price => @price)

    @ids = @student.download_images.pluck(:id) 

    if @cart.order_packages.where(:student_id => @student.id).joins(:package).where("lower(packages.name) like ?", "%fall%").any?
      @ids = @ids - @student.download_images.where(:folder => "fall2015").pluck(:id)
    end

    if @cart.order_packages.where(:student_id => @student.id).joins(:package).where("lower(packages.name) like ?", "%spring%").any?
      @ids = @ids - @student.download_images.where(:folder => "spring2016").pluck(:id)
    end
      
      @images = DownloadImage.where(id: @ids)

      @images.each do |image|
        if @images.where(:folder => image.folder).where(:year => image.year).count > 1
          @ids = @ids - [@images.where(:folder => image.folder).where(:year => image.year).first.id]
          @images = DownloadImage.where(id: @ids)
        end


      end
      @images = DownloadImage.find(@ids)

      if @images.any? && @cart.id_supplied?
        redirect_to previous_images_path(@cart.cart_id, @cart.students.count - 1)
      #elsif @cart.order_packages.where(:student_id => @student.id).joins(:package).where("lower(packages.name) like ?", "%senior%").any?
        #redirect_to senior_portraits_path(@cart.cart_id, params[:i])
      else
        redirect_to student_final_path(@cart.cart_id, @cart.students.count - 1)
      end
    
  end



  def select_package
    @cart = Cart.find_by_cart_id(params[:id])
    @i = params[:i]
    @student = @cart.students[params[:i].to_i]
    @opackages = @cart.order_packages.where(:student_id => @student.id).order(:id)
    @images = []

    @bool = []

    @cart.order_packages.each do |opackage|
      if opackage.options.any?
        @bool << true
      else
        @bool << false
      end
    end

    bucket = AWS::S3::Bucket.new('shoobphoto')
    @senior_url = []
    @grad_url = []

    @opackages.each do |opackage|
      package = opackage.package
      image = package.student_images.where(:student_id => @student.id).last

      if package.id == 6 && image.present?
        @senior_url = []
        @senior_id = []
        unless @cart.id_supplied == false
          for attribute in ['url', 'url1', 'url2', 'url3', 'url4']
            unless image.attributes[attribute].nil? || image.attributes[attribute] == ""
              if AWS::S3::S3Object.new(bucket, "images/watermarks/#{image.id}/watermark/#{image.attributes[attribute]}.jpg").exists?
                s3object = AWS::S3::S3Object.new(bucket, "images/watermarks/#{image.id}/watermark/#{image.attributes[attribute]}.jpg")
                @senior_url << s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
                @senior_id << "#{image.attributes[attribute]}"
              else

                @senior_id << "default"
              end
            end
          end
        else
          s3object = AWS::S3::S3Object.new(bucket, "images/package_types/#{package.id}/#{package.image_file_name}")
          @senior_url << s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
          @senior_id << "default"
        end
      end
      if package.id == 5  && image.present?
        @grad_url = []
        @grad_id = []
        unless @cart.id_supplied == false
          for attribute in ['url', 'url1', 'url2', 'url3', 'url4']
            unless image.attributes[attribute].nil? || image.attributes[attribute] == ""
              if AWS::S3::S3Object.new(bucket, "images/watermarks/#{image.id}/watermark/#{image.attributes[attribute]}.jpg").exists?
                s3object = AWS::S3::S3Object.new(bucket, "images/watermarks/#{image.id}/watermark/#{image.attributes[attribute]}.jpg")
                @grad_url << s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
                @grad_id << "#{image.attributes[attribute]}"
              else
                s3object = AWS::S3::S3Object.new(bucket, "images/package_types/#{package.id}/#{package.image_file_name}")
                @grad_url << s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
                @grad_id << "default"
              end
            end
          end
        else

          @grad_id << "default"
        end
      end
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
      student = @school.students.where("lower(first_name) like ? and lower(last_name) like ? and student_id = ? and id_only = ?", "%#{params[:first_name].downcase}%", "%#{params[:last_name].downcase}%", "#{params[:student_id].gsub(/\s+/, "")}", "true")
       
    
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
