class OrdersController < ApplicationController
	before_filter :authenticate_user!, only: [:index, :processed, :unprocessed]

	before_action :require_admin, only: [:index, :processed, :unprocessed]

	def download
		@order = Order.find(params[:id])

		if @order.cart.order_packages.map(&:download_image_id).any? && @order.cart.order_packages.map{ |o| o.options.map {|x| x.download }}.any? 
			@images = @order.cart.order_packages.where.not(download_image_id: nil).all
		else
			redirect_to root_path
		end
	end

	def create_package
		@cart = Cart.find_by_cart_id(params[:cart_id])
		@package = Package.find(params[:package])
		@student = Student.find(params[:student])
		@cart.order_packages.create(:package_id => @package.id, :student_id => @student.id, :option_id => @package.options.all.order(:name).first.id)
		@index = params[:index]
		@url = params[:url] 
		respond_to do |format|
			format.js
		end 
	end
  
	def delete_package
		@cart = Cart.find_by_cart_id(params[:cart_id])
		@package = Package.find(params[:package])
		@student = Student.find(params[:student])
		@index = params[:index]
		@url = params[:url]
		@cart.order_packages.where(:package_id => @package.id).where(:student_id => @student.id).destroy_all
		respond_to do |format|
			format.js
		end
	end

	def add_image
		@opackage = OrderPackage.find(params[:id])
		@opackage.update(:url => params[:url], :pose => params[:pose])
		@index = params[:index]

		respond_to :js
	end

	def new
		@cart = Cart.find_by_cart_id(params[:cart_id])

		if @cart.cart_type == 'catalog'
			@order = Order.new :price => @cart.price
		else
		@price = 0


	    @cart.order_packages.each do |package|
	    	package.options.each do |option|
	    		@price = option.price(package.student.school.id) + @price
	 		end
	    end

	    @cart.order_packages.each do |opackage|
	      if opackage.package.shippings.where(:school_id => Student.find(opackage.student_id).school.id).any?
	      @price = @price + opackage.package.shippings.where(:school_id => Student.find(opackage.student_id).school.id).first.price
	  	  elsif opackage.package.shippings.where(:school_id => nil).any?
	      @price = @price + opackage.package.shippings.where(:school_id => nil).first.price
	      end
	    end

		@cart.order_packages.each do |o|
			o.extras.each do |e|
				unless e.prices.first.try(:price).nil?
				@price = @price + e.prices.first.price
				end
			end
		end

   		 @cart.update(:price => @price)

		@order = Order.new :price => @price
	end
end

	def confirm
		@cart = Cart.find_by_cart_id(params[:cart_id])
		@order = @cart.orders.new (order_params).merge(:price => @cart.price)
	  	@order.ip_address = request.remote_ip	

	  if @order.save
	    	@cart.purchased = true
	    	@cart.cart_type = "school_pictures"
	    	@cart.save
	    	OrderMailer.receipt(@order).deliver

	    	if @order.cart.order_packages.map{ |x| x.options.map {|o| o.download}}.any?
	    		redirect_to order_download_path(@order.id), notice: "Your order has been successfully placed! We've emailed you a copy of your receipt. "
	    	else
	    		redirect_to root_path, notice: "Your order has been successfully placed! We've emailed you a copy of your receipt."
	    	end
	    else
	    	respond_to do |format|
	    	format.html { render 'new', :price => @order.price }
        	format.json { render json: @order.errors, status: :unprocessable_entity }
        	@order.errors.each do |order|
        		puts "#{order}"
        	end
        	end 
	    end

	end

	def show
		@order = Order.find(params[:id])
		@packages = @order.cart.packages.order(:id)
		@image_url = []

		bucket = AWS::S3::Bucket.new('shoobphoto')

		@packages.each do |package|
		@order.cart.students.each do |student|
		image = package.student_images.where(:student_id => student.id).last
		  unless image.nil?
        unless image.image_file_name.nil? || image.image_file_name == ""
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
		respond_to do |format| 
			format.html
			format.js
		end
	end

	def notprocessed
		@order = Order.find(params[:order_id])
		@student = Student.find(params[:student_id])
		@order.processed = false
		@order.save(:validate => false)

		respond_to do |format|
			format.js
		end
	end

	def processed
		@order = Order.find(params[:order_id])
		@student = Student.find(params[:student_id])
		@order.processed = true
		@order.save(:validate => false)

		respond_to do |format|
			format.js
		end
	end

	def find
		@school = School.find(params[:school][:id])
		@orders = Order.eager_load(cart: :student).where('students.school_id = ?', @school.id)
		
		respond_to do |format|
			format.js
		end
	end

	

	def index
		@search = Order.search(params[:q])
    	@orders = @search.result.paginate(:page => params[:page], :per_page => 200).order(:processed, :id)
    	@search.build_condition

    	respond_to do |format|
    		format.html
    			    			
	        
	    end
	
	end

	def export
		export = Export.create
    	OrderExport.perform_async(export.id)

    	redirect_to orders_path, notice: "The new order CSV is currently being generated."
    end

	def import
	unless params[:file].nil?
	  file = File.open(params[:file].tempfile, "r:ISO-8859-1")

    chunk = SmarterCSV.process(file, {:chunk_size => 500, row_sep: :auto}) do |chunk|
      OrderImport.perform_async(chunk)
    end
    file.close
	  redirect_to orders_path, notice: "Orders successfully imported."
	end
	end

  	def require_admin
    	unless current_user.try(:admin)
      	redirect_to root_path
    	end
  	end

	private
    # Use callbacks to share common setup or constraints between actions.
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:cart_id, :last_name, :first_name, :ip_address, :phone, :posted, :email, :price, :notes, :address, :city, :state, :zip_code, :card_type, :card_expires_on, :card_number, :card_verification, :shipping_state, :processed, :shipping_address, :shipping_zip, :shipping_city, :student_id, :school_id)
    end

end

