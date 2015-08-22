class OrdersController < ApplicationController
	before_filter :authenticate_user!, only: [:index, :processed, :unprocessed]

	before_action :require_admin, only: [:index, :processed, :unprocessed]

	def create_package
		@cart = Cart.find_by_cart_id(params[:cart_id])
		@image = StudentImage.find(params[:image])
		@package = @image.package
		@cart.order_packages.create(:package_id => @package.id, :student_id => @image.student_id)
		@index = params[:index]
		@url = params[:url]
		respond_to do |format|
			format.js
		end
	end

	def delete_package
		@cart = Cart.find_by_cart_id(params[:cart_id])
		@image = StudentImage.find(params[:image])
		@package = @image.package
		@index = params[:index]
		@url = params[:url]
		@cart.order_packages.where(:package_id => @package.id).where(:student_id => @image.student_id).destroy_all
		respond_to do |format|
			format.js
		end
	end

	def new
		@cart = Cart.find_by_cart_id(params[:cart_id])

		if @cart.cart_type == 'catalog'
			@order = Order.new
		else
		@price = 0


	    @cart.order_packages.each do |package|
	     @price = package.option.price + @price
	    end

	    @cart.order_packages.each do |opackage|
	      if opackage.package.shippings.where(:school_id => Student.find(opackage.student_id).school.id).any?
	      @price = @price + opackage.package.shippings.where(:school_id => Student.find(opackage.student_id).school.id).first.price
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
	    	redirect_to root_path, notice: "Your order has been successfully placed! We've emailed you a copy of your receipt."
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
      unless image.url.nil?
        if AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.url.upcase}.jpg").exists?
          s3object = AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.url.upcase}.jpg")
        else
          s3object = AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.url.downcase}.jpg")
        end
      else
        s3object = AWS::S3::S3Object.new(bucket, "images/package_types/#{image.package.id}/#{image.package.image_file_name}") #do default image in col later
      end

      @image_url << s3object.url_for(:read, :expires => 60.minutes)
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
		@order.update_attributes(:processed => false)

		respond_to do |format|
			format.js
		end
	end

	def processed
		@order = Order.find(params[:order_id])
		@student = Student.find(params[:student_id])
		@order.update_attributes(:processed => true)

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
    		format.csv do 
    			require 'csv'

    			csv_file = ''

    			csv_file << CSV.generate_line(@orders.first.attributes.keys[0..12].map{|column| column} + @orders.first.attributes.keys[14..21].map{|column| column} + ['Price'] + ['Student First Name'] + ['Student Last Name'] + ['Student Teacher'] + ['Student ID'] + ['Student Grade'] + ['Student SChool'] + ['Student DoB'] + ['Type'] + ['Package'] + ['8x10 | 5x7 | 3x5 | Wallets | Image CD | Name on Wallets | Retouching'])
            Order.where(:processed => false).each do |order|
            	order.cart.students.each do |student|

            if order.cart.order_packages.where(:student_id => student.id).count > 1

            	@string = order.cart.order_packages.where(:student_id => student.id).collect { |w| w.package.slug }.join(", ")
            else
            	@string = ""
            	order.cart.order_packages.where(:student_id => student.id).each do |opackage|
            		@string = @string + "#{opackage.package.slug}"
            	end
            end

            if order.cart.order_packages.where(:student_id => student.id).count > 1

            	@string2 = order.cart.order_packages.where(:student_id => student.id).collect { |w| w.option.name[-1] }.join(", ")
            else
            	@string2 = ""
            	order.cart.order_packages.where(:student_id => student.id).each do |opackage|
            		@string2 = @string2 + "#{opackage.option.name[-1]}"
            	end            end
            	
              csv_file << CSV.generate_line(order.attributes.values[0..12] + order.attributes.values[14..21] + ["#{Order.price(order.id, student.id)}"] +
              	["#{student.first_name}"] + ["#{student.last_name}"] + ["#{student.teacher}"] + ["#{student.student_id}"] + ["#{student.grade}"] + ["#{student.school.name}"] + ["#{student.dob}"] + 
              	
              	
           	
			[@string] + [@string2] + [Package.concat(order.id, student.id)]
              	

              )
          end
            end
	        send_data csv_file, :type => 'text/csv'
	        end
	    end
	
	end

	def import
	unless params[:file].nil?
	  Order.import(params[:file])
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

