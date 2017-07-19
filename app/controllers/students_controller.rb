class StudentsController < ApplicationController
  require 'aws-sdk'
  layout 'fullwidth'
  include Mobylette::RespondToMobileRequests

  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def find_student 
    respond_to do |format|
      format.mobile
      format.html
    end
  end

  def typeahead
    if params[:term]
      @schools = School.where("lower(name) like ?", "%#{params[:term].downcase}%").where.not(school_type_id: nil)

    end

    respond_to do |format|  
      format.html # index.html.erb  
  # Here is where you can specify how to handle the request for "/people.json"
      format.json { render :json => @schools.to_json }
      end
  end 


  def showteacher 
    @school = School.find(params[:school]) 
  end

  def add_package
    @cart = Cart.find_by_cart_id(params[:cart])
    @i = params[:i]
    @student = @cart.cart_students.order(:i).last.student
    @option = Option.find(params[:option])

    @opackage = @cart.order_packages.create(:package_id => @option.package.id, :student_id => @student.id, :student_image_id => params[:student_image_id])
    
    @opackage.options << @option

    redirect_to student_addons_path(@cart.cart_id, @i, @option.id, @opackage.id)
  end


  def addons
    @cart = Cart.find_by_cart_id(params[:cart])
    @i = params[:i]
    @student = @cart.cart_students.order(:i).last.student
    @option = Option.find(params[:option])
    array = @option.package.options.order(:name).map(&:id)
    @index = array.index(@option.id)
    @opackage = OrderPackage.find(params[:op])


    @image = @student.student_images.where(:package_id => @opackage.package.id).order(:folder).last

    unless @option.extra_types.any? 
      redirect_to student_update_path(@cart.cart_id, @cart.students.count - 1)
    end



  end

  def create_addons
    @opackage = OrderPackage.find(params[:opackage])
    @extra = Extra.find(params[:extra])
    @opackage.extras << @extra

    @price = 0

    @price = @opackage.options.last.price + @price
    @opackage.extras.each do |extra|
    @price = extra.prices.first.try(:price) + @price
    end
  end

  def delete_addon
    @opackage = OrderPackage.find(params[:opackage])
    @extra = Extra.find(params[:extra])
    @opackage.extras.delete(@extra)
    @price = 0

    @price = @opackage.options.last.price + @price
    @opackage.extras.each do |extra|
    @price = extra.prices.first.try(:price) + @price
    end
  end

  def add_pose
    @senior_image = SeniorImage.find(params[:url].to_i)
    @image = @senior_image.watermark.url
    @index = params[:index]
    @image_type = ImageType.find(params[:image_type])
    @opackage = OrderPackage.find(params[:opackage])
    @type = ImageType.classname(@image_type.id)
    @background = params[:background]
    
    OrderPackage.increment_counter(:extra_poses, @opackage.id)

  end

  def add_addon_pose
    @sheet = AddonSheet.find(params[:addon_sheet])
    @senior_image = SeniorImage.find(params[:senior_image_id])
    @sheet.update(:index => params[:index], :senior_image_id => @senior_image.id)
    @image = @senior_image.watermark.url
  end

  def view_addons
    @opackage = OrderPackage.find(params[:order_package])
    @cart = @opackage.cart
  end

  def view_package
    @opackage = OrderPackage.find(params[:order_package])
    @cart = @opackage.cart
  end

  def add_addon
    @opackage = OrderPackage.find(params[:order_package])
    @cart = @opackage.cart
    @addon = Addon.find(params[:addon])

    unless @opackage.addon_sheets.pluck(:addon_id).include? @addon.id
      @addon.image_count.times do |i|
        @opackage.addon_sheets.create(:addon_id => @addon.id, :index => i + 1)
      end
    end

  end

  def remove_addon
    @addon = Addon.find(params[:addon])
    @opackage = OrderPackage.find(params[:order_package])
    @opackage.addon_sheets.where(:addon_id => @addon.id).destroy_all
  end

  def update_senior_portraits
    @senior_image = SeniorImage.find(params[:url].to_i)
    @image = @senior_image.watermark.url
    @index = params[:index]
    @background = params[:background].to_i
    @image_type = ImageType.find(params[:image_type])
    @opackage = OrderPackage.find(params[:opackage])
    @type = ImageType.classname(@image_type.id)


 

    respond_to do |format|
      format.js 
    end
  end

  def yearbook
    @senior_image = SeniorImage.find(params[:url].to_i)
    @image = @senior_image.watermark.url
    @opackage = OrderPackage.find(params[:opackage])
    @background = params[:background]
    @opackage.update(:senior_image_id => @senior_image.id)
    @type = "yearbook"
    respond_to do |format|
      format.js
    end
  end

  def select
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @student = @cart.cart_students.order(:i).last.student

    if @cart.order_packages.where(:package_id => 6).any?
      @opackage = @cart.order_packages.where(:package_id => 6).last
    else
      @opackage = @cart.order_packages.create(:package_id => 6, :student_id => @student.id)
    end

    @opackage.options = []
    @opackage.sheets = []
    @opackage.update(:extra_poses => 0)
    @opackage.options << Option.find(params[:option])


    @ids = []
        if @student.student_images.any?

        added_folder = []

        @cart.order_packages.where(:student_id => @student.id).each do |opackage|
          added_folder << @student.student_images.where(:package_id => opackage.package_id).order(:folder).last.try(:folder)
        end

        folder = @student.student_images.pluck(:folder).uniq
        

        folder.each do |folder|
          unless added_folder.include?(folder)
            @ids << @student.student_images.where("folder like ?", "%#{folder}%").last.watermark.exists?
          end
        end

        else
          @ids << false
        end


      if @cart.order_packages.where(:student_id => @student.id).pluck(:package_id).include?(6) && @cart.id_supplied?
        redirect_to senior_portraits_path(@cart.cart_id, params[:i])
      elsif @ids.include?(true) && @cart.id_supplied?
        redirect_to previous_images_path(@cart.cart_id, @cart.students.count - 1)
      else
        redirect_to student_final_path(@cart.cart_id, @cart.students.count - 1)
      end 
  end

  def preview_image
    @image = params[:image] 
  end

  def senior_image_preview
    @image = SeniorImage.find(params[:image])
    @opackage = OrderPackage.find(params[:opackage])
  end

  def add_background
    @image = SeniorImage.find(params[:senior_image])
    @opackage = OrderPackage.find(params[:op])
    @background = Background.find(params[:background])
  end

  def senior_portraits 
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @student = @cart.cart_students.order(:i).last.student
    @i = params[:i]

    @opackage = @cart.order_packages.where(:package_id => 6).last

    @s_image = @opackage.package.student_images.where(:student_id => @student.id).last
    @senior_images = @s_image.senior_images.paginate(:per_page => 4, :page => params[:page])

    @package = @opackage.package
    image = @package.student_images.where(:student_id => @opackage.student.id).last

        if @package.id == 6 && image.present? && @cart.id_supplied?
          @boolean = false
          image.senior_images.each do |senior_image|
            if senior_image.watermark.exists?
            @boolean = true
            break
            end 
          end
        end

        @ids = []
        if @student.student_images.any?

        added_folder = []

        @cart.order_packages.where(:student_id => @student.id).each do |opackage|
          added_folder << @student.student_images.where(:package_id => opackage.package_id).order(:folder).last.try(:folder)
        end

        folder = @student.student_images.pluck(:folder).uniq
        

        folder.each do |folder|
          unless added_folder.include?(folder)
            @ids << @student.student_images.where("folder like ?", "%#{folder}%").last.watermark.exists?
          end
        end

        else
          @ids << false
        end
         
        unless @boolean == true
          if @ids.include?(true) && @cart.id_supplied?
            redirect_to previous_images_path(@cart.cart_id, @cart.students.count - 1)
          else
            redirect_to student_final_path(@cart.cart_id, @cart.students.count - 1)
          end
        end
         # have redirect here to final if no senior images exist. add redirect on previous page
  end

    def senior_portrait_addons
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @student = @cart.cart_students.order(:i).last.student
    @i = params[:i]

    @opackage = @cart.order_packages.where(:package_id => 6).last

      @s_image = @opackage.package.student_images.where(:student_id => @student.id).last

    bucket = AWS::S3::Bucket.new('shoobphoto')

    @package = @opackage.package
        image = @package.student_images.where(:student_id => @opackage.student.id).last

        if @package.id == 6 && image.present? && @cart.id_supplied?
          @boolean = false
          image.senior_images.each do |senior_image|
            if senior_image.image.exists?
            @boolean = true
            break
            end 
          end
        end

        @ids = []
        if @student.student_images.any?

        added_folder = []

        @cart.order_packages.where(:student_id => @student.id).each do |opackage|
          added_folder << @student.student_images.where(:package_id => opackage.package_id).order(:folder).last.try(:folder)
        end

        folder = @student.student_images.pluck(:folder).uniq
        

        folder.each do |folder|
          unless added_folder.include?(folder)
            @ids << @student.student_images.where("folder like ?", "%#{folder}%").last.watermark.exists?
          end
        end

        else
          @ids << false
        end
         
        unless @boolean == true
          if @ids.include?(true) && @cart.id_supplied?
            redirect_to previous_images_path(@cart.cart_id, @cart.students.count - 1)
          else
            redirect_to student_final_path(@cart.cart_id, @cart.students.count - 1)
          end
        end
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
    @option = Option.find(params[:option_id])
    @cart = @op.cart
    @student = @cart.cart_students.order(:i).last.student
    @op.options.delete(@option)
    @op.order_package_extras.where(:option_id => @option.id).destroy_all

    unless @op.options.any?
      @op.delete
    end

    @price = 0
      @cart.order_packages.each do |package|
        unless package.extra_poses.nil?
        @price = @price + package.extra_poses*25
        end
        package.options.each do |option|
           @price = option.price(@student.school.id) + @price
        end
      end

      @op.cart.order_packages.each do |opackage|

        opackage.options.each do |option|
          opackage.addon_sheets.each do |addon|
          if option.without? 
          @price = @price + addon.addon.price_without
          else 
          @price = @price + addon.addon.price_with
          end
          end
        end

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

  def remove_package
    @cart = Cart.find_by_cart_id(params[:id])
    @cart.order_packages.where(:download_image_id => params[:did]).last.delete
    @i = params[:did]

    @opackages = @cart.order_packages.pluck(:download_image_id)

  end

  def purchase
    @i = params[:i]
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @dimage = StudentImage.find(params[:image])
    @student = Student.find(params[:id])

   # @cart.order_packages.create(:package_id => id, :student_id => @student.id, :download_image_id => @dimage.id)
   if @dimage.package_id == 6
    @package = Package.find(6)
  else
    @package = Package.find(253)
  end

   if OrderPackage.where(:student_id => @student.id).where(:cart_id => @cart.id).where(:student_image_id => @dimage.id).any?
    @opackage = OrderPackage.where(:student_id => @student.id).where(:cart_id => @cart.id).where(:student_image_id => @dimage.id).last
    else
    @opackage = @package.order_packages.create(:student_id => @student.id, :cart_id => @cart.id, :student_image_id => @dimage.id)
    end
    #@cart.order_packages.last.update(:option_id => Package.find(id).options.first.id)
    @image_url = []

  end

  def create_cart
    @shoob_id = "#{params[:shoob_id].gsub(/\s+/, "").downcase}"
    if @shoob_id[4] == "5" || @shoob_id[4] == "1"
      @found_image = StudentImage.where("lower(shoob_id) = ?", "#{@shoob_id}").where(:folder => "fall2017").last
    elsif @shoob_id[4] == "2"
      @found_image = StudentImage.where("lower(shoob_id) = ?", "#{@shoob_id}").where(:folder => "spring2016").last
    elsif @shoob_id[4] == "3"
      @found_image = StudentImage.where("lower(shoob_id) = ?", "#{@shoob_id}").where(:folder => "grad2016").last
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
    @students_access = @school.student_images.where("accesscode = ?", "#{params[:student_id].gsub(/\s+/, "")}")
    @students_access_gift = @school.students.where("access_code = ?", "#{params[:student_id].gsub(/\s+/, "")[1..-1]}").where(:id_only => true)
    if @students.any? && (params[:student_id].gsub(/\s+/, "") != "" && params[:student_id] != nil)
      @student = @students.last
      respond_to :js 
    elsif @students_access.any? && (params[:student_id].gsub(/\s+/, "") != "" && params[:student_id] != nil)
      @student = @students_access.last.student

      respond_to :js
    elsif @students_access_gift.any? && (params[:student_id].gsub(/\s+/, "") != "" && params[:student_id] != nil)
      @student = @students_access_gift.last
      respond_to :js
    else
      render :nothing => true
    end
  end 

  def download
    @shoob_id = "#{params[:shoob_id].gsub(/\s+/, "").downcase}"
    if @shoob_id[4] == "5" || @shoob_id[4] == "1"
      @found_image = StudentImage.where("lower(shoob_id) = ?", "#{@shoob_id}").where(:folder => "fall2017").last
    elsif @shoob_id[4] == "2"
      @found_image = StudentImage.where("lower(shoob_id) = ?", "#{@shoob_id}").where(:folder => "spring2016").last
    elsif @shoob_id[4] == "3"
      @found_image = StudentImage.where("lower(shoob_id) = ?", "#{@shoob_id}").where(:folder => "grad2016").last
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
    @student = @cart.cart_students.order(:i).last.student
    @price = 0 
    if @cart.order_packages.any?
    unless @cart.order_packages.where.not(package_id: nil).first.package.nil? 
    if @cart.order_packages.where.not(package_id: nil).first.package.shippings.any?

          @price = @price + @cart.order_packages.where.not(package_id: nil).first.package.shippings.first.try(:price)
       
        end
      end
      @cart.order_packages.each do |package|
        unless package.extra_poses.nil?
        @price = @price + package.extra_poses*25
        end
        package.options.each do |option|
           @price = option.price(@student.school.id) + @price
        end

        package.gifts.each do |gift|
           @price = package.quantity*gift.price + @price
        end
      end 

      @cart.order_packages.each do |opackage|

        opackage.options.each do |option|
          opackage.addon_sheets.each do |addon|
          if option.without? 
          @price = @price + addon.addon.price_without
          else 
          @price = @price + addon.addon.price_with
          end
          end
        end

        
        opackage.extras.each do |e|
        unless e.prices.first.try(:price).nil?
        @price = @price + e.prices.first.price
        end
      end 
      end

       @cart.update(:price => @price)
       respond_to do |format|
        format.html
      end
     else
       
        redirect_to student_packages_path(@cart.cart_id, @cart.students.count - 1)
      end

      


  end

  def previous_images
    @i = params[:i]

    @cart = Cart.find_by_cart_id(params[:id])
    @student = @cart.cart_students.order(:i).last.student

    added_folder = []

    @cart.order_packages.where(:student_id => @student.id).each do |opackage|
      added_folder << @student.student_images.where(:package_id => opackage.package_id).order(:folder).last.try(:folder)
    end


    folder = @student.student_images.pluck(:folder).uniq
    @ids = []

    folder.each do |folder|
      unless added_folder.include?(folder)
        @ids << @student.student_images.where("folder like ?", "%#{folder}%").last.id
      end
    end

    @images = StudentImage.find(@ids).sort_by {|x| x.folder}.reverse
  end

  def update_cart
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @student = @cart.cart_students.order(:i).last.student
    @ids = []

    if @student.student_images.any?

    added_folder = []

    @cart.order_packages.where(:student_id => @student.id).each do |opackage|
      added_folder << @student.student_images.where(:package_id => opackage.package_id).order(:folder).last.try(:folder)
    end

    folder = @student.student_images.pluck(:folder).uniq

    folder.each do |folder|
      unless added_folder.include?(folder)
        @ids << @student.student_images.where("folder like ?", "%#{folder}%").last.watermark.exists?
      end
    end

    else
      @ids << false
    end
     
      if @ids.include?(true) && @cart.id_supplied?
        redirect_to previous_images_path(@cart.cart_id, @cart.students.count - 1)
      else
        redirect_to student_final_path(@cart.cart_id, @cart.students.count - 1)
      end
    
  end

  def add_options
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @i = params[:i].to_i
    @student = @cart.cart_students.order(:i).last.student
    @option = Option.find(params[:option_id])
    @op = OrderPackage.find(params[:op_id])
    
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

    @student = @cart.cart_students.order(:i).last.student
    @opackages = @cart.order_packages.where(:student_id => @student.id).order(:id)

  end

  def update
    @cart = Cart.find_by_cart_id(params[:id])
    @student = @cart.cart_students.order(:i).last.student

    @price = 0

    bool = []


    @cart.order_packages.each do |package|
     package.options.each do |option|
      @price = option.price(@student.school.id) + @price
     end
     package.gifts.each do |gift|
      @price = package.quantity*gift.price + @price
     end
    end


    unless @cart.order_packages.where.not(package_id: nil).first.nil? 
    if @cart.order_packages.where.not(package_id: nil).first.package.shippings.any?

      @price = @price + @cart.order_packages.where.not(package_id: nil).first.package.shippings.first.price
       end
    end

    @cart.update(:price => @price)

    @ids = []
        if @student.student_images.any?

        added_folder = []

        @cart.order_packages.where(:student_id => @student.id).each do |opackage|
            added_folder << @student.student_images.where(:package_id => opackage.package_id).order(:folder).last.try(:folder)
        end

        folder = @student.student_images.pluck(:folder).uniq
        

        folder.each do |folder|
          unless added_folder.include?(folder)
            @ids << @student.student_images.where("folder like ?", "%#{folder}%").last.watermark.exists?
          end
        end

        else
          @ids << false
        end

      if @ids.include?(true) && @cart.id_supplied? 
        redirect_to previous_images_path(@cart.cart_id, @cart.students.count - 1)
      else
        redirect_to student_final_path(@cart.cart_id, @cart.students.count - 1)
      end
    
  end



  def select_package
    @cart = Cart.find_by_cart_id(params[:id])
    @i = params[:i]
    @student = @cart.cart_students.order(:i).last.student
    @package = Package.find(params[:package]) 

    @image = @student.student_images.where(:package_id => @package.id).order(:folder).last   
  end 

  def packages
    @cart = Cart.find_by_cart_id(params[:id])
    @student = @cart.cart_students.order(:i).last.student
    @packages = @student.school.packages.order(:id)

  end

  def input
    @school = School.find(params[:school])
    @i = params[:i]
    @cart_id = params[:cart]

    if params[:cart].to_i == 1 
      @student = @school.students.create(:first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :teacher => params[:teacher], :grade => params[:grade])
      @cart = @student.carts.create(:email => params[:email], :school_id => @school.id, :cart_id => (0...8).map { (65 + rand(26)).chr }.join, :id_supplied => params[:id_supplied])
    else
      @cart = Cart.find_by_cart_id(params[:cart])
      @cart.update(:id_supplied => params[:id_supplied])
      @student = @cart.students.create( :first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :school_id => @school.id, :teacher => params[:teacher], :grade => params[:grade])
    end
     
      @cart.cart_students.last.update(:i => @cart.students.count - 1)
    redirect_to student_packages_path(@cart.cart_id, @i)
  end

  def splash
    @i = params[:i] unless params[:i].nil?
    @cart = params[:cart] unless params[:cart].nil?
  end


  def find
    @school = School.find(params[:school][:school_id])
    @i = (params[:i].nil? || params[:i] == "") ?  0 : params[:i]
    @cart_id = (params[:cart].nil? || params[:cart] == "") ?  1 : params[:cart]
    cookies[:user_email] = { :value => "#{params[:email]}", :expires => 5.years.from_now}


    if (params[:student_id].nil? || params[:student_id].strip == "") #if no student ID is entered

      student = @school.students.where("lower(first_name) like ? and lower(last_name) like ? and grade = ? and id_only = ?", "#{params[:first_name].downcase}", "%#{params[:last_name].downcase}%", "#{params[:grade]}", "true")
      
      if student.count > 0
        @student = student.last

        if @cart_id.to_i == 1
          @cart = @student.carts.create(:cart_id => (0...8).map { (65 + rand(26)).chr }.join, :id_supplied => false, :school_id => @school.id, :email => params[:email])
        else
          @cart = Cart.find_by_cart_id(params[:cart])
          @cart.update(:id_supplied => false)
          @cart.cart_students.create(:student_id => @student.id)
        end

        @cart.cart_students.last.update(:i => @cart.students.count - 1)

        respond_to do |format|
            format.html { redirect_to student_packages_path(@cart.cart_id, @cart.students.count - 1) }
            format.mobile { redirect_to student_packages_path(@cart.cart_id, @cart.students.count - 1) }
        end
 
      else #if no student found, create student

        respond_to do |format|
            format.mobile { redirect_to student_input_path(@school.id, @cart_id, @i, :first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :school_id => @school.id, :teacher => params[:student_teacher], :grade => params[:grade], :email => params[:email], :id_supplied => false) }
            format.html { redirect_to student_input_path(@school.id, @cart_id, @i, :first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :school_id => @school.id, :teacher => params[:student_teacher], :grade => params[:grade], :email => params[:email], :id_supplied => false) }
          end
  
      end

    else
      student = @school.students.where("lower(first_name) like ? and lower(last_name) like ? and student_id = ? and id_only = ?", "%#{params[:first_name].downcase}%", "%#{params[:last_name].downcase}%", "#{params[:student_id].gsub(/\s+/, "")}", "true")
      student_access = @school.student_images.where("accesscode = ?", "#{params[:student_id].gsub(/\s+/, "")}")
      student_access_gift = @school.students.where("lower(first_name) like ? and lower(last_name) like ? and access_code = ? and id_only = ?", "%#{params[:first_name].downcase}%", "%#{params[:last_name].downcase}%", "#{params[:student_id].gsub(/\s+/, "")[1..-1]}", "true")
      gift_code = params[:student_id][0].downcase
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

          @cart.cart_students.last.update(:i => @cart.students.count - 1)
          respond_to do |format|
              format.html { redirect_to student_packages_path(@cart.cart_id, @cart.students.count - 1) }
              format.mobile { redirect_to student_packages_path(@cart.cart_id, @cart.students.count - 1) }
          end
      elsif student_access.count > 0
        AccessCodeLog.create(:access_code => "#{params[:student_id]}")
        @student = student_access.last.student
          if @cart_id.to_i == 1
            @cart = @student.carts.create(:school_id => @school.id, :email => params[:email])
            @cart.cart_id = (0...8).map { (65 + rand(26)).chr }.join
            @cart.save
          else
            @cart = Cart.find_by_cart_id(params[:cart])
            @cart.cart_students.create(:student_id => @student.id)
          end

          @cart.cart_students.last.update(:i => @cart.students.count - 1)
          respond_to do |format|
              format.html { redirect_to student_select_package_path(@cart.cart_id, @cart.students.count - 1, student_access.last.package_id) }
              format.mobile { redirect_to student_select_package_path(@cart.cart_id, @cart.students.count - 1, student_access.last.package_id) }
          end
      elsif student_access_gift.count > 0 && gift_code.include?("g")
        AccessCodeLog.create(:access_code => "#{params[:student_id]}")
          @student = student_access_gift.last
          if @cart_id.to_i == 1
            @cart = @student.carts.create(:school_id => @school.id, :email => params[:email])
            @cart.cart_id = (0...8).map { (65 + rand(26)).chr }.join
            @cart.save
          else
            @cart = Cart.find_by_cart_id(params[:cart])
            @cart.cart_students.create(:student_id => @student.id)
          end

          @cart.cart_students.last.update(:i => @cart.students.count - 1)
          respond_to do |format|
              format.html { redirect_to gift_packages_path(@cart.cart_id, @cart.students.count - 1) }
              #format.mobile { redirect_to student_packages_path(@cart.cart_id, @cart.students.count - 1) }
          end
      else ## check for dob, then redirect if none found

          respond_to do |format|
            format.html { redirect_to student_input_path(@school.id, @cart_id, @i, :first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :school_id => @school.id, :teacher => params[:student_teacher], :dob => @dob, :grade => params[:grade], :email => params[:email], :id_supplied => "true") }
            format.mobile { redirect_to student_input_path(@school.id, @cart_id, @i, :first_name => params[:first_name], :last_name => params[:last_name], :student_id => params[:student_id], :school_id => @school.id, :teacher => params[:student_teacher], :dob => @dob, :grade => params[:grade], :email => params[:email], :id_supplied => "true") }

          end
      end
    end
  end

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
  end

  def gifts
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @i = params[:i].to_i
    @student = @cart.cart_students.order(:i).last.student
    @gifts = Gift.all.order(:name)

    if params[:download_image_id].nil? #check if cart has ID input - also check if last student updates cart
      @image = @student.student_images.where(folder: "fall2017").last
      unless @image.nil?
      @image.update(:watermark_file_name => @image.image_file_name)
      end
    else
    end
  end

  def show_gift
    @gift = Gift.find(params[:gift_id])
    @cart = Cart.find_by_cart_id(params[:cart_id])
    @i = params[:i].to_i
    @student = @cart.cart_students.order(:i).last.student
  end

  def add_gift
    @gift = Gift.find(params[:gift_id])
    @cart = Cart.find_by_cart_id(params[:cart_id]) 
    @i = params[:i].to_i
    @student = @cart.cart_students.order(:i).last.student
    @op = @cart.order_packages.create(:student_id => @student.id, :download_image_id => params[:download_image_id], :student_image_id => params[:image_id], :quantity => params[:quantity], :package_id => 256) 
    @op.gifts << @gift
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

    @i = params[:i] unless params[:i].nil?
    @cart = params[:cart] unless params[:cart].nil?

    respond_to do |format|
      format.html   
      format.mobile 
    end

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
